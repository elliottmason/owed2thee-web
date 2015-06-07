class CreateUserWithEmail < BaseService
  def initialize(email)
    @email = email
  end

  def perform
    ActiveRecord::Base.transaction do
      begin
        user.save!
        user_email.save! unless user_email.persisted?
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end
  end

  def user
    @user ||= User.new
  end

  def user_email
    return @user_email if @user_email

    @user_email = UserEmail.where(email: @email).first
    @user_email ||= UserEmail.new do |u|
      u.email = @email
      u.user  = user
    end
  end
end
