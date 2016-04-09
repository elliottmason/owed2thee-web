class EmailAddressConfirmation < TemporarySignin
  private

  def set_expires_at
    self[:expires_at] = Time.now.utc + 7.days
  end
end
