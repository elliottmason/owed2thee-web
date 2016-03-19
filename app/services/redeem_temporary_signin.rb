class RedeemTemporarySignin < ApplicationService
  include ChangeState

  transition :redeem

  def initialize(temporary_signin)
    @item = temporary_signin
  end

  def allowed?
    TemporarySigninPolicy.new(temporary_signin).redeem?
  end

  alias temporary_signin item
end
