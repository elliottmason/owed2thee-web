class ChangeTransferState < ApplicationService
  include ChangeState

  attr_reader :user

  def allowed?
    super && user.present?
  end

  alias transfer item

  private

  def broadcast_to_listeners
    type = transfer.class.to_s.underscore
    broadcast(:"#{transition}_#{type}_successful", transfer, user)
  end
end
