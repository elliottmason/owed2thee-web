class DisputeLoanParticipation < BaseService
  include Wisper::Publisher

  attr_reader :loan
  attr_reader :user

  def initialize(user, loan)
    @loan = loan
    @user = user

    subscribe(LoanParticipationListener.new)
  end

  def loan_participant
    @loan_participant = LoanParticipant.where(loan: loan, user: user).first
  end

  def perform
    @successful = loan_participant.dispute!

    broadcast(:dispute_loan_participation_successful, user, loan)
  end
end
