class LoanPolicy
  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def cancel?
    user_is_creator? && loan_is_unconfirmed? && loan_is_cancelable?
  end

  def confirm?
    ((user_is_creator? || loan_is_published?) &&
      user_is_unconfirmed_participant?) &&
      loan_is_confirmable?
  end

  def dispute?
    !user_is_creator? && user_is_participant? &&
      loan_is_disputable?
  end

  # def edit?
  #   user_is_creator? ||
  #     (loan_is_published? && loan_is_unconfirmed? &&
  #     user_is_unconfirmed_obligor?)
  # end

  def pay?
    loan_is_unpaid? && user_is_borrower?
  end

  def show?
    user_is_creator? || (loan_is_published? && user_is_participant?)
  end

  private

  attr_reader :loan

  def loan_participant
    @loan_participant ||= LoanParticipant.where(loan: loan, user: user).first
  end

  def loan_is_cancelable?
    loan.publicity.can_transition_to?(:canceled)
  end

  def loan_is_confirmable?
    loan_participant.confirmation.can_transition_to?(:confirmed)
  end

  def loan_is_disputable?
    loan_participant.confirmation.can_transition_to?(:disputed)
  end

  # def loan_is_disputed?
  #   loan.disputed?
  # end

  def loan_is_published?
    @loan.published?
  end

  def loan_is_unconfirmed?
    !@loan.confirmed?
  end

  def loan_is_unpaid?
    !@loan.fully_paid?
  end

  def user_is_borrower?
    loan_participant.is_a?(LoanBorrower)
  end

  def user_is_creator?
    loan.creator == @user
  end

  def user_is_participant?
    loan_participant
  end

  attr_reader :user

  def user_is_unconfirmed_participant?
    user_is_participant? && !loan_participant.confirmed?
  end
end
