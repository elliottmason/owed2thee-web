class LoanPolicy < ApplicationPolicy
  alias_method :loan, :record

  def index?
    user.present?
  end

  def cancel?
    user_is_creator? && loan_is_unconfirmed? && loan_is_cancelable?
  end

  def confirm?
    loan_is_confirmable? && user_is_recipient? && !user_is_creator?
  end

  def create?
    true
  end

  def dispute?
    loan_is_disputable? &&
      user_is_participant? && !user_is_creator?
  end

  def new?
    create?
  end

  def publish?
    user_is_creator? && loan_is_publishable?
  end

  def show?
    # can see any loan you've personally created irrespective of publicity
    # can see any loan you're involved in if it's published
    user_is_creator? || (loan_is_published? && user_is_participant?)
  end

  private

  def loan_is_cancelable?
    loan.publicity.can_transition_to?(:canceled)
  end

  def loan_is_confirmable?
    loan_is_published? && loan.confirmation.can_transition_to?(:confirmed)
  end

  def loan_is_disputable?
    loan.confirmation.can_transition_to?(:disputed)
  end

  def loan_is_publishable?
    loan.publicity.can_transition_to?(:published)
  end

  def loan_is_published?
    loan.published?
  end

  def loan_is_unconfirmed?
    !loan.confirmed?
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

  def user_is_recipient?
    loan.recipient == user
  end

  class Scope < Scope
    def resolve
      LoanQuery.for_user(user)
    end
  end
end
