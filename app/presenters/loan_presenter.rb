class LoanPresenter < TransferPresenter
  def borrower
    return @borrower if @borrower

    @borrower ||= display_name(loan.borrower)
  end

  def lender
    @lender ||= display_name(loan.lender, possessive: true)
  end

  alias_method :loan, :item
end
