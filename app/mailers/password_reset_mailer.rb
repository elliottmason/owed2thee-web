class PasswordResetMailer < TemporarySigninMailer
  private

  def reset?
    user.encrypted_password?
  end

  def subject
    return "[#{app_title}] - How to reset your password" if reset?
    "[#{app_title}] - How to sign in and set your password"
  end

  def url
    url_for([:edit, :user, :password, confirmation_token: confirmation_token])
  end
end
