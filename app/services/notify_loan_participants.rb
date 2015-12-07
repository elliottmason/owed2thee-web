# Sends emails to the borrowers or lenders of a Loan, prompting them to confirm
# the validity of the Loan. Gets sent to everyone who isn't the creator of the
# Loan. (We might need a separate email copy for creators.)
class NotifyLoanParticipants < BaseService
  def initialize(loan)
    @loan = loan
  end

  def perform
    # @loan.loan_participants.in_state(:unconfirmed).map do |loan_participant|
    #   LoanParticipationMailer.email(loan_participant).deliver_later
    # end

    @successful = true
  end
end
