class EmailAddressListener
  def confirm_email_address_successful(email_address)
    ConfirmUser.with(email_address.user)
  end

  def create_email_address_successful(email_address)
    CreateEmailAddressConfirmation.with(email_address)
  end
end
