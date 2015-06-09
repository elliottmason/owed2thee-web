class ConfirmUser < BaseService
  include Wisper::Publisher

  attr_reader :user

  def initialize(user = nil)
    @user = user
  end

  def confirm_user_email_successful(email)
    self.class.with(email.user)
  end

  def perform
    @successful = user.confirm!

    broadcast(:confirm_user_successful) if successful?
  end

  def successful?
    @successful
  end
end
