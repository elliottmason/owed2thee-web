class ConfirmUser < ApplicationService
  include ChangeState

  attr_reader :user

  subscribe UserListener.new

  transition :confirm

  def initialize(user)
    @item = @user = user
  end

  def successful?
    user.confirmed?
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_user_successful, user)
  end
end
