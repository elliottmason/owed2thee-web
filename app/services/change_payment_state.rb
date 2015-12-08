class ChangePaymentState < ChangeTransferState
  subscribe PaymentListener.new

  alias_method :payment, :transfer
end
