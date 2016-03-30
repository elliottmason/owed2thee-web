class LoanPresenter < TransferPresenter
  def activities
    @activities ||= loan.activities.where(recipient: viewer)
  end

  def amount_lent
    return unless loan

    amount_for(loan)
  end

  def borrower(*args)
    return @borrower if @borrower

    @borrower ||= display_name(loan.borrower, *args)
  end

  def lender(*args)
    @lender ||= display_name(loan.lender, *args)
  end

  alias loan item
end
