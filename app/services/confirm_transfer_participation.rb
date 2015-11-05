class ConfirmTransferParticipation < ConfirmItem
  include Wisper::Publisher

  attr_reader :user

  def initialize(user, *args)
    @user = user
    super(*args)
  end

  def allowed?
    participant.present?
  end

  def participant
    @participant ||= TransferParticipant.where(transfer:  transfer,
                                               user:      user).first
  end

  alias_method :_item, :item
  alias_method :item, :participant
  alias_method :transfer, :_item

  private

  def broadcast_to_listeners
    broadcast(:confirm_transfer_participation_successful, user, transfer)
  end
end
