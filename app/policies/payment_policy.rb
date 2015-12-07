class PaymentPolicy
  def initialize(user, payment)
    @payment  = payment
    @user     = user
  end

  def confirm?
    puts payment.confirmation.current_state

    payment_is_unconfirmed? &&
      user_is_participant? &&
      payment.confirmation.can_transition_to?(:confirmed)
  end

  def show?
    user_is_creator? || user_is_participant?
  end

  private

  attr_reader :payment
  attr_reader :user

  def payment_is_unconfirmed?
    payment.unconfirmed?
  end

  def user_is_creator?
    payment.creator == user
  end

  def user_is_participant?
    user_is_payee? || user_is_payer?
  end

  def user_is_payee?
    payment.payee == user
  end

  def user_is_payer?
    payment.payer == user
  end
end
