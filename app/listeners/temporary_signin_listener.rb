class TemporarySigninListener
  def redeem_temporary_signin_successful(temporary_signin)
    ConfirmEmailAddress.for(temporary_signin.email_address)
  end
end
