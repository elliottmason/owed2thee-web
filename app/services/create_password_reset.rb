class CreatePasswordReset < CreateTemporarySignin
  alias password_reset record

  subscribe PasswordResetListener.new

  private

  def broadcast_to_listeners
    broadcast(:create_password_reset_successful, password_reset)
  end

  def create_record
    @record = PasswordReset.create!(email_address:  email_address,
                                    user:           user)
  end
end
