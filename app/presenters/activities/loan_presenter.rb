module Activities
  class LoanPresenter < BasePresenter
    def amount_lent
      loan.amount.format if loan
    end

    def borrower
      return @borrower if @borrower

      @borrower = 'them' \
        if loan.borrower == activity.owner && activity.owner != viewer
      @borrower ||= display_name_for(loan.borrower)
    end

    def lender
      return @lender if @lender

      @lender = '' if loan.lender == activity.owner
      @lender ||= display_name_for(loan.lender, possessive: true)
    end

    alias_method :loan, :transfer
  end
end
