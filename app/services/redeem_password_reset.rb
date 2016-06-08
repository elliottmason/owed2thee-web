class RedeemPasswordReset < RedeemTemporarySignin
  subscribe TemporarySigninListener.new

  transition :redeem

  private

  def broadcast_to_listeners
    broadcast(:redeem_temporary_signin_successful, temporary_signin)
  end
end
