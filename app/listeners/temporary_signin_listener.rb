class TemporarySigninListener
  def create_temporary_signin_successful(temporary_signin)
    TemporarySigninMailer.email(temporary_signin).deliver_later!
  end

  def redeem_temporary_signin_successful(temporary_signin)
    ConfirmEmailAddress.for(temporary_signin.email_address)
  end
end
