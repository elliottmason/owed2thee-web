class DisputeLoanParticipation < BaseService
  attr_reader :loan
  attr_reader :user

  def initialize(user, loan)
    @loan = loan
    @user = user
  end

  def loan_participant
    @loan_participant = LoanParticipant.where(loan: loan, user: user).first
  end

  def perform
    @successful = loan_participant.dispute!
  end
end
