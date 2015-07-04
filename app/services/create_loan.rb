class CreateLoan < BaseService
  include Wisper::Publisher

  def initialize(creator, params)
    @creator  = creator
    @params   = params
  end

  def borrowers
    type == :debt ? [creator] : obligors
  end

  def creator
    @creator ||= find_creator_by_email_address || create_creator
  end

  delegate :creator_email_address, to: :form

  def form
    @form ||= LoanForm.new(@params)
  end

  def group
    @group ||= LoanGroup.new
  end

  def lenders
    type == :loan ? [creator] : obligors
  end

  def loan
    return @loan if @loan

    @loan = Loan.new do |l|
      l.borrower  = borrowers.first
      l.creator   = creator
      l.lender    = lenders.first
      l.amount    = form.amount
    end
  end

  def obligors
    return @obligors if @obligors

    @obligors = []
    @obligors += find_obligors_by_email_addresses
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

  def unregistered_creator?
    @unregistered_creator
  end

  alias_method :user, :creator

  private

  def broadcast_to_listeners
    broadcast(:create_loan_successful, loan)
  end

  def create_creator
    @unregistered_creator = true
    CreateUserWithEmailAddress.with(creator_email_address).user
  end

  def create_loan
    loan.borrowers  = borrowers
    loan.lenders    = lenders
    loan.save!
    loan.groups << group
    loan.valid?
  end

  def find_creator_by_email_address
    EmailAddress.where(address: creator_email_address).first.try(:user)
  end

  def find_obligors_by_email_addresses
    [FindOrCreateUserByEmailAddress.with(form.obligor_email_address).user]
  end
end
