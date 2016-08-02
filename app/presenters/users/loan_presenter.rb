module Users
  class LoanPresenter < TransferPresenter
    def tone
      sender? ? 'neutral' : 'negative'
    end

    def type
      sender? ? 'loan_received' : 'loan_sent'
    end
  end
end
