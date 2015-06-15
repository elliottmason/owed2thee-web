class CreateLoan < BaseService
  include Wisper::Publisher

  def initialize(creator, params)
    @creator  = creator
    @params   = params

    subscribe_to_listeners
  end

  def borrowers
    type == :debt ? [creator] : obligors
  end

  def broadcast_to_listeners
    broadcast(:create_loan_successful, loan) if successful?
  end

  def create_loan
    loan.borrowers  = borrowers
    loan.lenders    = lenders
    loan.save!
    loan.groups << group
  end

  def create_creator
    @unregistered_creator = true
    CreateUserWithEmail.with(creator_email).user
  end

  def creator
    @creator ||= find_creator_by_email || create_creator
  end

  delegate :creator_email, to: :form

  def find_creator_by_email
    UserEmail.where(email: creator_email).first.try(:user)
  end

  def find_obligors_by_emails
    [FindOrCreateUserByEmail.with(form.obligor_email).user]
  end

  # TODO: find user IDs with which creator has a relationship
  def find_obligors_by_ids
    []
  end

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
      l.amount    = form.amount_dollars
      l.amount_cents += form.amount_cents
    end
  end

  def obligors
    return @obligors if @obligors

    @obligors = []
    @obligors += find_obligors_by_emails
    @obligors += find_obligors_by_ids
    @obligors.uniq!
    @obligors
  end

  def perform
    return unless form.valid?

    ActiveRecord::Base.transaction do
      begin
        create_loan
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end

    broadcast_to_listeners
  end

  def subscribe_to_listeners
  end

  def successful?
    loan.valid?
  end

  def type
    form.type.to_sym
  end

  def unregistered_creator?
    @unregistered_creator
  end

  alias_method :user, :creator
end
