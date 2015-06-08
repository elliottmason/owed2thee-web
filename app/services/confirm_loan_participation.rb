class ConfirmLoanParticipation < BaseService
  def initialize(loan_participant)
    @loan_participant = loan_participant

    subscribe(PublishLoan)
  end

  def peform
    @successful = @loan_participant.confirm!

    broadcast(:confirm_loan_participation_successful, @loan_participant)
  end

  def successful?
    @successful
  end
end
