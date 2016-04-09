class EmailAddressConfirmationMailerPresenter < ApplicationPresenter
  def confirmation_path
    [email_address_confirmation, :redemption]
  end

  alias email_address item

  def email_address_confirmation
    @email_address_confirmation ||=
      EmailAddressConfirmationQuery.most_recent_email_address(email_address)
  end
end
