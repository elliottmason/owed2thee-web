class CreateLoan < BaseService
  include Wisper::Publisher

  attr_reader :creator
  attr_reader :loan

  def initialize(creator, params)
    @creator  = creator
    @params   = params
  end

  def borrowers
    type == :debt ? [creator] : obligors
  end

  def create_loan
    loan.borrowers = borrowers
    loan.save!
  end

  def creator
    return @creator if @creator

    return unless creator_email

    extant_email = UserEmail.where(email: creator_email).first
    @creator =  if extant_email && extant_email.uncomfirmed?
                  extant_email.user
                elsif extant_email.nil?
                  CreateUserWithEmail.with(creator_email).user
                end
  end

  delegate :creator_email, to: :form

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
    @group ||= LoanGroup.create
  end

  def lender
    type == :loan ? creator : obligors.first
  end

  def loan
    return @loan if @loan

    @loan = Loan.new do |l|
      l.group   = group
      l.creator = creator
      l.lender  = lender
      l.amount  = form.amount_dollars
      l.amount_cents += form.amount_cents
    end
  end

  # TODO: eventually support multiple borrowers
  def obligor_emails
    [form.obligor_email]
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
    ActiveRecord::Base.transaction do
      begin
        create_loan
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end

    broadcast(:loan_created, loan) if successful?
  end

  def successful?
    loan.valid?
  end

  def type
    form.type.to_sym
  end
end
