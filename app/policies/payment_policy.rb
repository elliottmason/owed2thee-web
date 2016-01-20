class PaymentPolicy < ApplicationPolicy
  alias_method :payment, :record

  def confirm?
    payment_is_confirmable? && user_is_participant? && !user_is_creator?
  end

  def publish?
    user_is_creator? && payment_is_publishable?
  end

  def show?
    user_is_creator? || user_is_participant?
  end

  private

  def payment_is_confirmable?
    payment_is_published? && payment.confirmation.can_transition_to?(:confirmed)
  end

  def payment_is_publishable?
    payment.publicity.can_transition_to?(:published)
  end

  def payment_is_published?
    payment.published?
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
