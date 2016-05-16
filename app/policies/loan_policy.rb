class LoanPolicy < ApplicationPolicy
  def cancel?
    loan_is_cancelable? && user_is_creator? && loan_is_unconfirmed?
  end

  def confirm?
    loan_is_confirmable? && user_is_participant? && !user_is_creator?
  end

  def create?
    true
  end

  def dispute?
    loan_is_disputable? && user_is_participant? && !user_is_creator?
  end

  def index?
    user.present?
  end

  alias loan record

  def new?
    create?
  end

  def pay?
    loan_is_payable? && user_is_borrower? && lender_is_payable?
  end

  def publish?
    loan_is_publishable? && user_is_creator?
  end

  def show?
    # can see any loan you've personally created irrespective of publicity
    # can see any loan you're involved in if it's published
    user_is_creator? || (loan_is_published? && user_is_participant?)
  end

  private

  def lender_is_payable?
    UserPolicy.new(user, loan.lender).pay?
  end

  def loan_is_cancelable?
    loan.publicity.can_transition_to?(:canceled)
  end

  def loan_is_confirmable?
    loan_is_published? && loan.confirmation.can_transition_to?(:confirmed)
  end

  def loan_is_confirmed?
    loan.confirmed?
  end

  def loan_is_disputable?
    loan.confirmation.can_transition_to?(:disputed)
  end

  def loan_is_payable?
    loan.balance_cents > 0
  end

  def loan_is_publishable?
    loan.publicity.can_transition_to?(:published)
  end

  def loan_is_published?
    loan.published?
  end

  def loan_is_unconfirmed?
    !loan_is_confirmed?
  end

  def user_is_borrower?
    loan.borrower == user
  end

  def user_is_creator?
    loan.creator == user
  end

  def user_is_lender?
    loan.lender == user
  end

  def user_is_participant?
    user_is_borrower? || user_is_lender?
  end

  class Scope < Scope
    def resolve
      LoanQuery.for_user(user)
    end
  end
end
