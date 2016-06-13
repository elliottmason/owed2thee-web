class EmailAddressConfirmationListener
  def redeem_email_address_confirmation_successful(email_address_confirmation)
    ConfirmEmailAddress.with(email_address_confirmation.email_address)
  end
end
