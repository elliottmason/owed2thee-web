class PasswordResetListener
  def create_password_reset_successful(password_reset)
    PasswordResetMailer.email(password_reset).deliver_later
  end
end
