class PaymentPresenter < TransferPresenter
  alias_method :amount_paid, :amount

  def i18n_key
    return unless viewer

    payment.payer == viewer ? :as_payer : :as_payee
  end

  def loan
    payment.payable
  end

  def payers
    return 'your' if viewer == payment.payer

    @payers ||= join_display_names(payment.payers, true)
  end

  alias_method :payment, :item

  def viewer_type
    return unless viewer
    return :payee if viewer_is_payee?
    return :payer if viewer_is_payer?
  end

  def viewer_is_payer?
    return false unless viewer

    payment.payers.include?(viewer)
  end

  def viewer_is_payee?
    return false unless viewer

    payment.payees.include?(viewer)
  end
end
