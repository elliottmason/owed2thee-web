class CreateLedgersForLoanParticipant < ApplicationService
  attr_reader :ledgers
  attr_reader :loan
  attr_reader :user

  def initialize(loan, user)
    @loan = loan
    @user = user
  end

  def perform
    find_or_create = FindOrCreateLedger.between(loan.lender, loan.borrower)
    @successful = find_or_create.ledger.persisted?
  end
end
