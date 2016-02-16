class CreatePasswordReset < CreateTemporarySignin
  attr_reader :email_address

  def initialize(email_address)
    super(email_address, email_address.user)
  end

  def create_temporary_signin
    @temporary_signin = PasswordReset.create!(email_address:  email_address,
                                              user:           user)
  end

  alias_method :password_reset, :temporary_signin
end
