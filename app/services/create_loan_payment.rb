class CreateLoanPayment < ApplicationService
  include BroadcastToListeners

  attr_reader :loan
  attr_reader :loan_payment
  attr_reader :payment

  def initialize(loan, payment)
    @loan     = loan
    @payment  = payment
  end

  def allowed?
    payment_is_applicable?
  end

  def perform
    create_loan_payment
    raise ActiveRecord::Rollback unless successful?
  end

  def payment_is_applicable?
    PaymentPolicy.new(payment.payer, payment, loan).apply?
  end

  def successful?
    loan_payment.persisted?
  end

  private

  def applicable_amount
    [loan.balance, payment.balance].min
  end

  def create_loan_payment
    @loan_payment =
      LoanPayment.create do |lp|
        lp.loan     = loan
        lp.payment  = payment
        lp.amount   = applicable_amount
      end
  end
end
