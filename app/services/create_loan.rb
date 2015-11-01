class CreateLoan < BaseService
  include Wisper::Publisher

  attr_reader :loan
  attr_reader :unregistered_creator

  delegate :creator_email_address, to: :form

  def initialize(creator, params)
    @creator  = creator
    @params   = params

    subscribe(LoanListener.new)
  end

  def borrowers
    @borrowers ||= { debt: [creator], loan: obligors }[type]
  end

  def creator
    @creator ||= find_creator_by_email_address
  end

  def form
    @form ||= LoanForm.new(@params)
  end

  def group
    @group ||= LoanGroup.new
  end

  def lenders
    @lenders ||= { debt: obligors, loan: [creator] }[type]
  end

  def obligors
    return @obligors if @obligors

    @obligors = find_obligors_by_email_addresses
    @obligors.uniq!
    @obligors
  end

  def perform
    return unless form.valid?

    ActiveRecord::Base.transaction do
      begin
        @successful = create_loan
      rescue ActiveRecord::RecordInvalid
        form.errors = loan.errors.dup
        raise ActiveRecord::Rollback
      end
    end

    broadcast_to_listeners if successful?
  end

  def type
    form.type.to_sym
  end

  alias_method :unregistered_creator?, :unregistered_creator

  alias_method :user, :creator

  private

  def assign_loan_relationships
    @loan.creator         = creator
    @loan.borrowers       = borrowers
    @loan.borrower        = borrowers.first
    @loan.lenders         = lenders
    @loan.lender          = lenders.first
    @loan.email_addresses = email_addresses
  end

  def broadcast_to_listeners
    broadcast(:create_loan_successful, self)
  end

  def build_loan
    @loan = Loan.new(amount: form.amount)
    assign_loan_relationships
  end

  def create_loan
    build_loan
    loan.save!
    loan.groups << group

    loan.valid?
  end

  def email_addresses
    @email_addresses ||= []
  end

  def find_creator_by_email_address
    finder = FindOrCreateUserByEmailAddress.with(creator_email_address)
    @unregistered_creator = finder.new_user?
    finder.user
  end

  def find_obligors_by_email_addresses
    finder = FindOrCreateUserByEmailAddress.with(form.obligor_email_address)
    email_addresses << finder.email_address
    [finder.user]
  end
end
