class PaymentPresenter < TransferPresenter
  alias_method :amount_paid, :amount

  def loan
    payment.payable
  end

  def payers
    return 'your' if viewer_is_payer?

    @payers ||= join_display_names(payment.payers, true)
  end

  alias_method :payment, :item

  def viewer_is_payer?
    return false unless viewer

    payment.payers.include?(viewer)
  end
end
