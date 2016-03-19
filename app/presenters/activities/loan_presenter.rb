module Activities
  class LoanPresenter < Activities::BasePresenter
    def amount_lent
      loan.amount.format if loan
    end

    def borrower
      return @borrower if @borrower

      @borrower ||= 'them' \
        if loan.borrower == activity.owner && activity.owner != viewer
      @borrower ||= display_name_for(loan.borrower)
    end

    def lender
      return @lender if @lender

      @lender ||= 'your' if loan.lender == viewer
      @lender ||= display_name_for(loan.lender, possessive: true)
    end

    alias loan transfer
  end
end
