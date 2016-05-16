module Loans
  class ConfirmationMailerPresenter < BaseMailerPresenter
    def borrower
      @borrower ||= display_name(loan.borrower)
    end

    def lender
      @lender ||= display_name(loan.lender, possessive: true)
    end

    def subject
      "[#{h.t('app.title')}] - #{obligor} confirmed your loan"
    end

    def path
      [loan]
    end

    private

    def obligor
      @obligor ||= display_name(loan.obligor)
    end
  end
end
