class RedeemTemporarySignin < ApplicationService
  include ChangeState

  transition :redeem

  def initialize(temporary_signin)
    @item = temporary_signin
  end

  def allowed?
    temporary_signin.unredeemed?
  end

  alias_method :temporary_signin, :item
end
