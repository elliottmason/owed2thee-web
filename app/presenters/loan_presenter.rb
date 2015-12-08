class LoanPresenter < TransferPresenter
  def borrower
    return @borrower if @borrower

    @borrower ||= display_name(loan.borrower)
  end

  def lender
    @lender ||= display_name(loan.lender, possessive: true)
  end

  alias_method :loan, :item

  def viewer_is_borrower?
    viewer_is?(:borrower)
  end

  def viewer_is_lender?
    viewer_is?(:lender)
  end
end
