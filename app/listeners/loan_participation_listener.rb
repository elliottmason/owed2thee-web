class LoanParticipationListener
  def confirm_loan_participation_successful(user, loan)
    CreateLedgersForLoanParticipant.with(user, loan)
    PublishLoan.with(loan) if loan.creator_id == user.id
  end
end
