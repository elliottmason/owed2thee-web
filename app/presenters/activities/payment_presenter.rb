module Activities
  class PaymentPresenter < BasePresenter
    def amount_paid
      payment.amount.format if payment
    end

    def payee
      display_name_for(payment.payee)
    end

    def payer
      display_name_for(payment.payer, possessive: true)
    end

    alias payment transfer
  end
end
