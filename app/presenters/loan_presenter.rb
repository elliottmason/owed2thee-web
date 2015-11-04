class LoanPresenter < TransferPresenter
  def borrowed?
    loan.borrowers.include?(viewer)
  end

  def lent
    loan.lenders.include?(viewer)
  end

  def i18n_key
    borrowed? ? :as_borrower : :as_lender
  end

  alias_method :loan, :item
end
