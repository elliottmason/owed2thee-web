# Sends emails to the borrowers or lenders of a Loan, prompting them to confirm
# the validity of the Loan.
class NotifyLoanParticipants < ApplicationService
  attr_reader :loan

  def initialize(loan)
    @loan = loan
  end

  def perform
    LoanParticipationMailer.email(loan, loan.obligor).deliver_later

    @successful = true
  end
end
