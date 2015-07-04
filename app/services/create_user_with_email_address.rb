class CreateUserWithEmailAddress < BaseService
  def initialize(email_address)
    @email_address = email_address
  end

  def email_address
    return @email_address if @email_address.is_a?(EmailAddress)

    @email_address = EmailAddress.new do |e|
      e.address = @email_address
      e.user    = user
    end
  end

  def perform
    ActiveRecord::Base.transaction do
      begin
        user.email_addresses << email_address
        user.save!
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end
  end

  def user
    @user ||= User.new
  end
end
