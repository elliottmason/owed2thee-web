class FindOrCreatePasswordReset < ApplicationService
  attr_reader :email_address
  attr_reader :email_address_string
  attr_reader :password_reset
  attr_reader :user

  def initialize(email_address_string)
    @email_address_string = email_address_string
  end

  def perform
    return unless retrieve_email_address

    @password_reset =
      begin
        PasswordResetQuery.recent_email_address!(email_address)
      rescue ActiveRecord::RecordNotFound
        create_password_reset
      end

    @successful = password_reset.persisted?
  end

  private

  def create_password_reset
    CreatePasswordReset.with(email_address).password_reset
  end

  def retrieve_email_address
    @email_address = EmailAddressQuery.address!(email_address_string)
  end
end
