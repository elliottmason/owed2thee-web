class PublishLoan < PublishTransfer
  def initialize(*args)
    super
    subscribe(LoanListener.new)
  end
end
