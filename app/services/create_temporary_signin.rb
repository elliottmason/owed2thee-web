class CreateTemporarySignin < ApplicationService
  include BroadcastToListeners

  attr_reader :record

  delegate :user, to: :email_address

  def initialize(email_address)
    @email_address = email_address
  end

  def email_address
    return unless @email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address = EmailAddressQuery.address!(@email_address)
  end

  def perform
    ActiveRecord::Base.transaction do
      cancel_previous_records
      create_record
    end
    @successful = record.persisted?

    broadcast_to_listeners if successful?
  end

  private

  def broadcast_to_listeners
    broadcast(:create_temporary_signin_successful, record)
  end

  def cancel_previous_records
    TemporarySigninQuery.user(user).each(&:cancel!)
  end

  def create_record
    @record = TemporarySignin.create!(
      email_address:  email_address,
      user:           user
    )
  end
end
