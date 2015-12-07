class DisputeTransfer < ChangeTransferState
  def initialize(transfer, user)
    @item = transfer
    @user = user
  end

  alias_method :transfer, :item

  private

  def broadcast_to_listeners
    broadcast(:dispute_transfer_successful, transfer, creator)
  end
end
