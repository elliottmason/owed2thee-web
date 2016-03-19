class TemporarySigninPolicy < ApplicationPolicy
  attr_reader :temporary_signin

  def initialize(temporary_signin)
    @temporary_signin = temporary_signin
  end

  def redeem?
    unexpired? && unredeemed?
  end

  private

  def unexpired?
    temporary_signin.expires_at > Time.now.utc
  end

  def unredeemed?
    temporary_signin.unredeemed?
  end
end
