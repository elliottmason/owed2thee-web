class LoanListener
  def confirm_transfer_successful(_loan)
  end

  def create_transfer_successful(_loan)
  end

  def publish_loan_successful(loan)
    RecordTransferActivity.with(loan, :created)
    NotifyLoanParticipants.with(loan)
  end
  alias_method :publish_transfer_successful, :publish_loan_successful
end
