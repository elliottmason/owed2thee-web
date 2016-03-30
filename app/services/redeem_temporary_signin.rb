class RedeemTemporarySignin < ApplicationService
  include ChangeState

  transition :redeem

  def initialize(temporary_signin)
    @item = temporary_signin
  end

  def allowed?
    item.present? && TemporarySigninPolicy.new(item).redeem?
  end

  alias temporary_signin item
end
