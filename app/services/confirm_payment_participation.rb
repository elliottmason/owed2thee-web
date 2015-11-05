class ConfirmPaymentParticipation < ConfirmTransferParticipation
  def initialize(*args)
    super
    subscribe(PaymentParticipationListener.new)
  end
end
