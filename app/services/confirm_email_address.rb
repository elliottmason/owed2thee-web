class ConfirmEmailAddress < ApplicationService
  include ChangeState

  attr_reader :email_address

  delegate :user, to: :email_address, allow_nil: true

  transition :confirm

  def initialize(email_address)
    @item = @email_address = email_address

    subscribe(EmailAddressListener.new)
  end

  def allowed?
    EmailAddressPolicy.new(nil, email_address).confirm?
  end

  def successful?
    email_address.confirmed?
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_email_address_successful, email_address)
  end
end
