class RecalculatePaymentBalance < ApplicationService
  attr_reader :payment

  def initialize(payment)
    @payment = payment
  end

  def perform
    recalculate_payment_balance
    raise ActiveRecord::Rollback unless successful?
  end

  private

  def payment_balance
    payment.amount_cents - payment.loan_payments.sum(:amount_cents)
  end

  def recalculate_payment_balance
    @successful =
      payment.update_attributes(balance_cents: payment_balance)
  end
end
