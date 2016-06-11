class CreateTemporarySignin < ApplicationService
  include BroadcastToListeners

  attr_reader :record

  delegate :user, to: :email_address

  subscribe TemporarySigninListener.new

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
  end

  private

  def cancel_previous_records
    TemporarySigninQuery.active_for_user(user).each(&:cancel!)
  end
end
