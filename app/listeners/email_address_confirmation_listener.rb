class EmailAddressConfirmationListener
  def create_email_address_confirmation_successful(email_address_confirmation)
    EmailAddressConfirmationMailer.
      email(email_address_confirmation).
      deliver_later
  end

  def redeem_email_address_confirmation_successful(email_address_confirmation)
    ConfirmEmailAddress.with(email_address_confirmation.email_address)
  end
end
