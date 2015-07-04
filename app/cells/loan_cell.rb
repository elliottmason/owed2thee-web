class LoanCell < BaseCell
  property :amount
  property :created_at
  property :transitions

  private

  property :borrower

  def currency_symbol
    amount.currency.symbol
  end

  # 1. TODO: We need to record the actual email to which the Loan was submitted
  #          so that we don't reveal another email for the same user
  # 2. TODO: We want to show the full name if the two users have a Ledger
  #          already. This will require a profile model of some kind.
  def borrower_name
    @borrower_name = borrower.email_addresses.first.address
  end
end
