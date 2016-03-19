class ChangePaymentState < ChangeTransferState
  subscribe PaymentListener.new

  alias payment transfer
end
