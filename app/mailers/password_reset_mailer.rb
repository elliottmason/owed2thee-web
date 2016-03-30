class PasswordResetMailer < TemporarySigninMailer
  private

  def subject
    "[#{app_title}] - How to reset your password"
  end
end
