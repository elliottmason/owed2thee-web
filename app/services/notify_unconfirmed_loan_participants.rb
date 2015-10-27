class NotifyUnconfirmedLoanParticipants < BaseService
  def initialize(loan)
    @loan = loan
  end

  def perform
    @loan.loan_participants.in_state(:unconfirmed).map do |loan_participant|
      LoanParticipationMailer.email(loan_participant).deliver_later
    end

    @successful = true
  end
end
