class ConfirmPayment < ChangePaymentState
  transition :confirm

  def perform
    if user == payment.creator
      @successful = PublishPayment.with(payment, user).successful?
    else
      super
    end
  end
end
