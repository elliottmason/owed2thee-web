class CreateEmailAddressConfirmation < CreateTemporarySignin
  def initialize(*args)
    super
    subscribe(EmailAddressConfirmationListener.new)
  end

  alias email_address_confirmation record

  def allowed?
    !email_address.confirmed?
  end

  private

  def broadcast_to_listeners
    broadcast(:create_email_address_confirmation_successful,
              email_address_confirmation)
  end

  def create_record
    @record =
      EmailAddressConfirmation.create!(
        email_address:  email_address,
        user:           user
      )
  end
end
