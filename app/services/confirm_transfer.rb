class ConfirmTransfer < ConfirmItem
  attr_reader :user

  def initialize(transfer, user)
    @transfer = transfer
    @user     = user
    super(transfer)
  end

  def perform
    return PublishTransfer.with(transfer, user) if user == transfer.creator

    super
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_transfer_successful, transfer, user)
  end
end
