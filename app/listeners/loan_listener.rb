class LoanListener
  def cancel_loan_successful(loan, user)
    RecordTransferActivity.with(loan, :canceled, user)
  end

  def confirm_loan_successful(loan, user)
    CreateUserContactsForTransferParticipant.with(loan, user)
    Loans::ConfirmationMailer.email(loan, loan.creator).deliver_later
    RecalculateLedger.for(*loan.participants)
    RecordTransferActivity.with(loan, :confirmed, user)
  end

  def create_loan_successful(loan, _user = nil)
    NotifyLoanCreatorForConfirmation.with(loan)
  end

  def dispute_loan_successful(loan, user)
    RecordTransferActivity.with(loan, :disputed, user)
  end

  def publish_loan_successful(loan, user)
    FindOrCreateLedger.for(loan.lender, loan.borrower)
    CreateUserContactsForTransferParticipant.with(loan, user)
    NotifyLoanObligor.for(loan)
    RecordTransferActivity.with(loan, :created)
  end
end
