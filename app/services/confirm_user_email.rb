class ConfirmEmailAddress < BaseService
  include Wisper::Publisher

  def initialize(email_address, confirmation_token)
    @email_address      = email_address
    @confirmation_token = confirmation_token

    subscribe(ConfirmUser.new)
  end

  def email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address =
      EmailAddress \
      .in_state(:unconfirmed) \
      .where(confirmation_token: @confirmation_token, address: @email_address)
      .first
  end

  def perform
    return unless email_address

    email_address.confirm!

    broadcast(:confirm_email_address_successful, email_address) if successful?
  end

  def successful?
    email_address && email_address.confirmed?
  end

  delegate :user, to: :email_address
end
