class RedeemTemporarySignin < ChangeState
  def initialize(temporary_sign_in)
    super(temporary_sign_in, :redeem)
  end
end
