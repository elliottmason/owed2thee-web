class CreateLedgersForLoanParticipant < BaseService
  attr_reader :ledgers
  attr_reader :loan
  attr_reader :user

  def initialize(loan, user)
    @loan = loan
    @user = user
  end

  def perform
    @successful =
      FindOrCreateLedger.between(loan.lender, loan.borrower).ledger.persisted?
  end
end
