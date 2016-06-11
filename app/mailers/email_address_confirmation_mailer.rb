class EmailAddressConfirmationMailer < TemporarySigninMailer
  private

  alias email_address_confirmation temporary_signin

  def subject
    "[#{t('app.title')}] - Confirm your email address"
  end

  def url
    [email_address_confirmation, :redemption]
  end
end
