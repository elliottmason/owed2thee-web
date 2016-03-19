class FindOrCreateUserByEmailAddress < ApplicationService
  attr_reader :email_address
  attr_reader :new_user
  attr_reader :user

  def initialize(email_address_string)
    @email_address_string = email_address_string
  end

  alias new_user? new_user

  def perform
    create_user

    @successful = user.present?
  end

  private

  def create_user
    find_or_create_email_address
    @user = email_address.user if email_address
  end

  def find_or_create_email_address
    @email_address = EmailAddress.where(address: @email_address_string).first
    @new_user = true unless @email_address
    @email_address ||=
      CreateUserWithEmailAddress.with(@email_address_string).email_address
  end
end
