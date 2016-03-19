class LoanPresenter < TransferPresenter
  def borrower(*args)
    return @borrower if @borrower

    @borrower ||= display_name(loan.borrower, *args)
  end

  def lender(*args)
    @lender ||= display_name(loan.lender, *args)
  end

  alias loan item
end
