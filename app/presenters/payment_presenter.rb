class PaymentPresenter < TransferPresenter
  alias_method :amount_paid, :amount

  def payee
    @payee ||= display_name(transfer.payee)
  end

  def payer
    @payer ||= display_name(transfer.payer, possessive: true)
  end

  alias_method :payment, :item
end
