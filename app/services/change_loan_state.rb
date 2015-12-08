class ChangeLoanState < ChangeTransferState
  subscribe LoanListener.new

  alias_method :loan, :transfer
end
