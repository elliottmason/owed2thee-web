class ConfirmLoan < ChangeLoanState
  transition :confirm

  def perform
    return PublishLoan.with(loan, user) if user == loan.creator

    super
  end
end
