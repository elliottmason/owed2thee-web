class ConfirmUser < ApplicationService
  include ChangeState

  attr_reader :user

  transition :confirm

  def initialize(user)
    @item = @user = user
  end

  def successful?
    user.confirmed?
  end
end
