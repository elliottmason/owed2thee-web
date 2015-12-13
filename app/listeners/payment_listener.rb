class PaymentListener
  def confirm_payment_successful(payment, user)
    RecalculateLedger.with(*payment.participants)
    RecordTransferActivity.with(payment, :confirmed, user)
  end

  def create_payment_successful(_payment)
  end

  def publish_payment_successful(payment, user)
    RecalculateLedger.with(*payment.participants)
    RecordTransferActivity.with(payment, :created, user)
  end
end
