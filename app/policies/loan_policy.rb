class LoanPolicy
  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def cancel?
    user_is_creator? && loan_is_unconfirmed? && loan_is_cancelable?
  end

  def confirm?
    loan_is_confirmable? && user_is_recipient? && !user_is_creator?
  end

  def dispute?
    loan_is_disputable? &&
      user_is_participant? && !user_is_creator?
  end

  def publish?
    user_is_creator? && loan_is_publishable?
  end

  def show?
    user_is_creator? || (loan_is_published? && user_is_participant?)
  end

  private

  attr_reader :loan
  attr_reader :user

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
end
