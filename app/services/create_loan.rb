class CreateLoan < ApplicationService
  include BroadcastToListeners

  attr_reader :loan
  attr_reader :unregistered_creator

  delegate :creator_email_address, to: :form

  def initialize(creator, params)
    @creator  = creator
    @params   = params

    subscribe(LoanListener.new)
  end

  def borrower
    @borrower ||= { debt: creator, loan: obligor }[type]
  end

  def creator
    @creator ||= find_creator_by_email_address
  end

  def form
    @form ||= LoanForm.new(@params)
  end

  def lender
    @lender ||= { debt: obligor, loan: creator }[type]
  end

  def obligor
    return @obligor if @obligor

    @obligors = find_obligor_by_email_address
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

    super
  end

  def type
    form.type.to_sym
  end

  alias unregistered_creator? unregistered_creator

  alias user creator

  private

  def assign_loan_relationships
    @loan.creator   = creator
    @loan.borrower  = borrower
    @loan.lender    = lender
  end

  def broadcast_to_listeners
    broadcast(:create_loan_successful, loan, creator)
  end

  def build_loan
    @loan = Loan.new(amount:        form.amount,
                     contact_name:  form.obligor_email_address)
    assign_loan_relationships
  end

  def create_loan
    build_loan
    loan.save!

    loan.valid?
  end

  def email_addresses
    @email_addresses ||= []
  end

  def find_creator_by_email_address
    finder = FindOrCreateUserByEmailAddress.with(creator_email_address)
    email_addresses << finder.email_address
    @unregistered_creator = finder.new_user?
    finder.user
  end

  def find_obligor_by_email_address
    finder = FindOrCreateUserByEmailAddress.with(form.obligor_email_address)
    email_addresses << finder.email_address
    finder.user
  end
end
