class CancelTransfer < ChangeTransferState
  def initialize(transfer, user = nil)
    super(transfer, :cancel, user)
  end
end
