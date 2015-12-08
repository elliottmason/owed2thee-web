class ConfirmEmailAddress < BaseService
  include BroadcastToListeners

  delegate :user, to: :email_address, allow_nil: true

  subscribe ConfirmUser.new

  def initialize(email_address, confirmation_token)
    @confirmation_token = confirmation_token
    @email_address      = email_address
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

    super
  end

  def broadcast_to_listeners
    broadcast(:confirm_email_address_successful, email_address)
  end

  def successful?
    email_address.present? && email_address.confirmed?
  end
end
