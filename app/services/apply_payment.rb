class ApplyPayment < ApplicationService
  attr_reader :payment

  def initialize(payment)
    @payment = payment
  end

  def perform
    ActiveRecord::Base.transaction do
      RecalculatePaymentBalance.for(payment)
      payment.reload.loans.each { |loan| RecalculateLoanBalance.for(loan) }
      @successful = true
    end
  end
end
