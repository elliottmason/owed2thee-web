class ChangePaymentState < ChangeTransferState
  subscribe :PaymentListener

  alias_method :payment, :transfer
end
