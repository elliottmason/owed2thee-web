class CreatePaymentForLoan < CreatePayment
  attr_reader :loan
  attr_reader :loan_payment

  def initialize(creator, loan, params)
    @loan = loan
    super(creator, loan.lender, params)
  end

  def perform
    ActiveRecord::Base.transaction do
      super
      create_loan_payment
      puts @loan_payment.persisted?
    end
  end

  def successful?
    super && loan_payment && loan_payment.persisted?
  end

  private

  def create_loan_payment
    @loan_payment = CreateLoanPayment.with(loan, payment).loan_payment
  end
end
