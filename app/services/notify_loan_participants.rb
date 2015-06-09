class NotifyLoanParticipants < BaseService
  def initialize(loan = nil)
    @loan = loan
  end

  def perform
    @loan.loan_participants.in_state(:unconfirmed).each do |loan_participant|
      next if @loan.creator == loan_participant.user

      LoanParticipationMailer.email(loan_participant).deliver
    end
  end

  private

  def publish_loan_successful(loan)
    self.class.with(loan)
  end
end
