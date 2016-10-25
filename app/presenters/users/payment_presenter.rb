module Users
  class PaymentPresenter < TransferPresenter
    def tone
      sender? ? 'positive' : 'neutral'
    end

    def type
      sender? ? 'payment_received' : 'payment_sent'
    end
  end
end
