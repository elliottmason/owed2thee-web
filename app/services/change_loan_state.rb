class ChangeLoanState < ChangeTransferState
  subscribe LoanListener.new

  alias loan transfer
end
