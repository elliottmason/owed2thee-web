class ChangePaymentState < ChangeTransferState
  def initialize(*args)
    super
    subscribe(PaymentListener.new)
  end

  alias payment transfer
end
