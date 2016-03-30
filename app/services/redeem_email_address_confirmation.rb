class RedeemEmailAddressConfirmation < RedeemTemporarySignin
  include ChangeState

  attr_reader :confirmation_token

  delegate :email_address, to: :email_address_confirmation
  delegate :user, to: :email_address

  subscribe EmailAddressConfirmationListener.new

  transition :redeem

  def initialize(confirmation_token)
    @confirmation_token = confirmation_token
  end

  def email_address_confirmation
    return @email_address_confirmation if defined?(@email_address_confirmation)

    @email_address_confirmation ||=
      begin
        EmailAddressConfirmationQuery.confirmation_token!(confirmation_token)
      rescue ActiveRecord::RecordNotFound
        return @successful = false
      end
  end

  alias item email_address_confirmation

  private

  def broadcast_to_listeners
    broadcast(:redeem_email_address_confirmation_successful,
              email_address_confirmation)
  end
end
