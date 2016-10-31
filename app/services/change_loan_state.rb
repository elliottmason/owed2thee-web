class ChangeLoanState < ChangeTransferState
  def initialize(*args)
    super
    subscribe(LoanListener.new)
  end

  alias loan transfer
end
