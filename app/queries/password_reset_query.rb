class PasswordResetQuery < TemporarySigninQuery
  def initialize(relation = PasswordReset.all)
    super
  end
end
