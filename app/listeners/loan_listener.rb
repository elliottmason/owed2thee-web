class LoanListener
  def confirm_transfer_successful(_loan)
  end

  def create_transfer_successful(_loan)
  end

  def publish_transfer_successful(loan)
    RecordTransferActivity.with(loan, :created)
    NotifyUnconfirmedLoanParticipants.with(loan)
  end
end
