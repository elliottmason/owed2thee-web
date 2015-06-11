class LoanPolicy
  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def cancel?
    creator? && unconfirmed? && loan.publicity.can_transition_to?(:canceled)
  end

  def confirm?
    unconfirmed_obligor?
  end

  def dispute?
    !creator? && obligor? &&
      loan_participant.confirmation.can_transition_to?(:disputed)
  end

  def edit?
    participant?
  end

  def show?
    participant?
  end

  private

  def borrower?
    @loan.borrowers.include?(@user)
  end

  def creator?
    @loan.creator == @user
  end

  def disputed?
    @loan.disputed?
  end

  def lender?
    @loan.lenders.include?(@user)
  end

  attr_reader :loan

  def loan_participant
    @loan_participant ||= LoanParticipant.where(loan: loan, user: user).first
  end

  def obligor?
    published? && (borrower? || lender?)
  end

  def participant?
    creator? || obligor?
  end

  def published?
    @loan.published?
  end

  def unconfirmed?
    !@loan.confirmed?
  end

  def unconfirmed_obligor?
    loan_participant && !loan_participant.confirmed?
  end

  attr_reader :user
end
