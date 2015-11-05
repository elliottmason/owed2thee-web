class PaymentListener
  def create_transfer_successful(_payment)
  end

  def publish_transfer_successful(payment)
    RecordTransferActivity.with(payment, :created)
    # Notify payment recipients
  end
end
