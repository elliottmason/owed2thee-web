class ConfirmTransfer < ConfirmItem
  delegate :participants, to: :transfer

  alias_method :transfer, :item

  def confirmed_by_all_participants?
    participants.in_state(:confirmed).count == participants.count
  end

  def broadcast_to_listeners
    broadcast(:confirm_transfer_successful, transfer)
  end

  private

  def allowed?
    confirmed_by_all_participants?
  end
end
