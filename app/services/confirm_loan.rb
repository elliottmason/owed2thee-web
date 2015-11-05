class ConfirmLoan < ConfirmTransfer
  def initialize(*args)
    super
    subscribe(LoanListener.new)
  end
end
