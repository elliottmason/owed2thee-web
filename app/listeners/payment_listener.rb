class PaymentListener
  def confirm_payment_successful(payment, user)
    ApplyPayment.with(payment)
    RecalculateLedger.with(*payment.participants)
    RecordTransferActivity.with(payment, :confirmed, user)
  end

  def publish_payment_successful(payment, user)
    RecalculateLedger.with(*payment.participants)
    RecordTransferActivity.with(payment, :created, user)
  end
end
