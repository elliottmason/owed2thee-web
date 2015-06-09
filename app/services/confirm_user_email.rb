class ConfirmUserEmail < BaseService
  include Wisper::Publisher

  def initialize(email_address, confirmation_token)
    @email_address      = email_address
    @confirmation_token = confirmation_token

    subscribe(ConfirmUser.new)
  end

  def email
    @email ||=
      UserEmail \
      .in_state(:unconfirmed) \
      .where(confirmation_token: @confirmation_token, email: @email_address)
      .first
  end

  def perform
    return unless email

    email.confirm!

    broadcast(:confirm_user_email_successful, email) if successful?
  end

  def successful?
    email && email.confirmed?
  end

  delegate :user, to: :email
end
