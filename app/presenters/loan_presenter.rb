class LoanPresenter < TransferPresenter
  # def borrowed?
  #   loan.borrowers.include?(viewer)
  # end
  #
  # def lent
  #   loan.lenders.include?(viewer)
  # end

  alias_method :loan, :item
end
