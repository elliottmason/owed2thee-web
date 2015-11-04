class LoanParticipationListener
  def confirm_loan_participation_successful(user, loan)
    ConfirmLoan.with(loan)
    PublishLoan.with(loan)
    CreateLedgersForLoanParticipant.with(user, loan)
    CreateUserContactsForTransferParticipant.with(user, loan)
    RecordTransferActivity.with(user, loan, :confirmed) \
      unless loan.creator_id == user.id
  end

  def dispute_loan_participation_successful(user, loan)
    RecordTransferActivity.with(user, loan, :disputed)
  end
end
