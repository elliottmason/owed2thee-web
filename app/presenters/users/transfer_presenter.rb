module Users
  class TransferPresenter < ApplicationPresenter
    def self.new(object, *args)
      return super unless self == Users::TransferPresenter

      case object
      when Loan
        Users::LoanPresenter.new(object, *args)
      when Payment
        Users::PaymentPresenter.new(object, *args)
      end
    end

    def amount
      transfer.amount.format
    end

    def date
      transfer.created_at.strftime('%b %e')
    end

    def description
      I18n.t("transfers.descriptions.#{type}")
    end

    def status
      transfer.current_state
    end

    alias transfer item

    private

    def sender?
      transfer.sender == viewer
    end
  end
end
