class CreateUserWithEmailAddress < ApplicationService
  include BroadcastToListeners

  def initialize(email_address)
    @email_address = email_address

    subscribe(EmailAddressListener.new)
  end

  def email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address = EmailAddress.new do |e|
      e.address = @email_address
      e.user    = user
    end
  end

  def perform
    user.email_addresses << email_address
    @successful = user.save
    super
  end

  def user
    @user ||= User.new
  end

  private

  def broadcast_to_listeners
    broadcast(:create_email_address_successful, email_address)
  end
end
