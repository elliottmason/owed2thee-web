class RecalculateLedger < BaseService
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

    @successful = ledger.update_balances!
  end
end
