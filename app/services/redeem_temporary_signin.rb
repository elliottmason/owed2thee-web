class RedeemTemporarySignin < BaseService
  include ChangeState

  def initialize(temporary_signin)
    super(temporary_signin, :redeem)
  end

  def allowed?
    temporary_signin.unredeemed?
  end

  alias_method :temporary_signin, :item
end
