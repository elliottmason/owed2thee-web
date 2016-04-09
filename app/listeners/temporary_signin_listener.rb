class TemporarySigninListener
  def create_temporary_signin_successful(temporary_signin)
    TemporarySigninMailer.email(temporary_signin).deliver_later!
  end
end
