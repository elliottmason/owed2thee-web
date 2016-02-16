class CreateTemporarySignin < BaseService
  include Wisper::Publisher

  attr_reader :temporary_signin
  attr_reader :user

  def initialize(email_address, user)
    @email_address = email_address
    @user = user
    subscribe_to_listeners
  end

  def email_address
    return unless @email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address = EmailAddressQuery.address!(@email_address)
  end

  def perform
    ActiveRecord::Base.transaction do
      cancel_previous_records
      create_temporary_signin
    end
    @successful = temporary_signin.persisted?

    broadcast_to_listeners if successful?
  end

  private

  def broadcast_to_listeners
    broadcast(:create_temporary_signin_successful, temporary_signin)
  end

  def cancel_previous_records
    TemporarySigninQuery.user(user).each(&:cancel!)
  end

  def create_temporary_signin
    @temporary_signin = TemporarySignin.create!(
      email_address:  email_address,
      user:           user
    )
  end

  def subscribe_to_listeners
    subscribe(TemporarySigninListener.new)
  end
end
