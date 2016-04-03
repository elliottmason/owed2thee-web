class EmailAddressPolicy < TemporarySigninPolicy
  def confirm?
    email_address_is_confirmable? &&
      (email_address_user_is_unconfirmed? || email_address_belongs_to_user?)
  end

  alias email_address temporary_signin

  private

  def email_address_is_confirmable?
    email_address.confirmation.can_transition_to?(:confirmed)
  end

  def email_address_user_is_unconfirmed?
    !email_address.user.confirmed?
  end

  def email_address_belongs_to_user?
    user.present? && email_address.user == user
  end
end
