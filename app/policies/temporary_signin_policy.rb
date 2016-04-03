class TemporarySigninPolicy < ApplicationPolicy
  def redeem?
    unexpired? && unredeemed?
  end

  alias temporary_signin record

  private

  def unexpired?
    temporary_signin.expires_at > Time.now.utc
  end

  def unredeemed?
    temporary_signin.unredeemed?
  end
end
