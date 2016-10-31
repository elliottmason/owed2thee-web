class RedeemPasswordReset < RedeemTemporarySignin
  transition :redeem

  def initialize(*args)
    super
    subscribe(TemporarySigninListener.new)
  end

  private

  def broadcast_to_listeners
    broadcast(:redeem_temporary_signin_successful, temporary_signin)
  end
end
