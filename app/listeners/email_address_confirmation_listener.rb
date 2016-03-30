class EmailAddressConfirmationListener
  def create_email_address_confirmation_successful(email_address_confirmation)
    # if email_address_confirmation.user.confirmed?
    #   # send normal email address confirmation mail
    # end
  end

  def redeem_email_address_confirmation_successful(email_address_confirmation)
    ConfirmEmailAddress.with(email_address_confirmation.email_address)
  end
end
