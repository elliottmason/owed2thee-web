class FindOrCreateUserByEmail < BaseService
  attr_reader :user

  def initialize(email)
    @email = email
  end

  def user_email
    @user_email ||= UserEmail.where(email: @email).first
  end

  def user
    return @user if @user

    @user = user_email.user if user_email
    @user ||= CreateUserWithEmail.with(@email).user
  end
end
