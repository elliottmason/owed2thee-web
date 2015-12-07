class LoanPresenter < TransferPresenter
  def borrower
    return @borrower if @borrower

    @borrower ||= 'your' if viewer == loan.borrower
    @borrower ||= UserPresenter.new(loan.borrower, viewer, loan).display_name
  end

  def lender
    return @lender if @lender

    @lender ||= 'your' if viewer == loan.lender
    @lender ||= UserPresenter.new(loan.lender, viewer, loan).display_name
  end

  alias_method :loan, :item
end
