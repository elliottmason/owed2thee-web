class LoanListener
  def cancel_loan_successful(loan, user)
    RecordTransferActivity.with(loan, :canceled, user)
  end

  def create_loan_successful(_loan)
  end

  def confirm_loan_successful(loan, user)
    CreateUserContactsForTransferParticipant.with(loan, user)
    RecalculateLedger.for(*loan.participants)
    RecordTransferActivity.with(loan, :confirmed, user)
  end

  def dispute_loan_successful(loan, user)
    RecordTransferActivity.with(loan, :disputed, user)
  end

  def publish_loan_successful(loan, user)
    CreateLedgersForLoanParticipant.with(loan, user)
    CreateUserContactsForTransferParticipant.with(loan, user)
    NotifyLoanParticipants.with(loan)
    RecalculateLedger.for(*loan.participants)
    RecordTransferActivity.with(loan, :created)
  end
end
