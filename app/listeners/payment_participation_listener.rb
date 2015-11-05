class PaymentParticipationListener
  def confirm_transfer_participation_successful(user, payment)
    ConfirmPayment.with(payment)
    PublishPayment.with(payment)
    RecordTransferActivity.with(user, payment, :confirmed) \
      unless payment.creator_id == user.id
  end

  def dispute_transfer_participation_successful(user, payment)
    RecordTransferActivity.with(user, payment, :disputed)
  end
end
