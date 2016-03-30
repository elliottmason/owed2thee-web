class ConfirmUser < ApplicationService
  include ChangeState

  attr_reader :user

  subscribe(UserListener.new)

  transition :confirm

  def initialize(user)
    @user = user
  end

  alias item user

  def successful?
    user.confirmed?
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_user_successful, user)
  end
end
