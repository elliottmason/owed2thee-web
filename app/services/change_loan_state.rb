class ChangeLoanState < ChangeTransferState
  subscribe :LoanListener

  alias_method :loan, :transfer
end
