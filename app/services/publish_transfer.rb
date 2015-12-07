class PublishTransfer < PublishItem
  def initialize(creator, transfer)
    @creator  = creator
    @item     = transfer
  end

  # def allowed?
  #   confirmed_by_creator?
  # end
  #
  # def confirmed_by_creator?
  #   TransferParticipantQuery.confirmed_creator_for(transfer).exists?
  # end

  alias_method :transfer, :item

  private

  def broadcast_to_listeners
    broadcast(:publish_transfer_successful, transfer, creator)
  end
end
