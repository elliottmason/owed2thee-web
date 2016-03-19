class RecalculateLedger < ApplicationService
  attr_reader :user_a
  attr_reader :user_b

  def initialize(user_a, user_b)
    @user_a = user_a
    @user_b = user_b
  end

  def ledger
    @ledger ||= LedgerQuery.between!(user_a, user_b)
  end

  def perform
    return unless ledger

    ledger.update_balances
    @successful = ledger.save
  end
end
