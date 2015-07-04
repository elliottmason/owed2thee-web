class FindOrCreateUserByEmailAddress < BaseService
  attr_reader :user

  def initialize(email_address)
    @email_address = email_address
  end

  def perform
    @successful = user.present?
  end

  def email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address = \
      EmailAddress.where(address: @email_address).first ||
      CreateUserWithEmailAddress.with(@email_address).email_address
  end

  def user
    return @user if @user

    @user = email_address.user if email_address
  end
end
