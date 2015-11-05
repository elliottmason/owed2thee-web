class PublishPayment < PublishTransfer
  def initialize(*args)
    super
    subscribe(PaymentListener.new)
  end
end
