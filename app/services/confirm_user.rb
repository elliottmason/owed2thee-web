class ConfirmUser < BaseService
  include Wisper::Publisher

  attr_reader :user

  def initialize(user = nil)
    @user = user
  end

  def confirm_email_address_successful(email_address)
    self.class.with(email_address.user)
  end

  def perform
    @successful = user.confirm!

    broadcast(:confirm_user_successful) if successful?
  end

  def successful?
    @successful
  end
end
