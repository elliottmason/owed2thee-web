class LoanListener
  def confirm_loan_successful(_loan)
  end

  def create_loan_successful(_loan)
  end

  def publish_loan_successful(loan)
    RecordTransferActivity.with(loan, :created)
    NotifyUnconfirmedLoanParticipants.with(loan)
  end
end
