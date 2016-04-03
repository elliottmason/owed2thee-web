class RecalculateLedger < ApplicationService
  attr_reader :user_a
  attr_reader :user_b

  def initialize(user_a, user_b)
    @user_a = user_a
    @user_b = user_b
  end

  def allowed?
    ledger.present?
  end

  def ledger
    return @ledger if defined?(@ledger)

    @ledger = LedgerQuery.first_between(user_a, user_b)
  end

  def perform
    super
    ledger.update_attributes(
      confirmed_balance_cents: calculate_confirmed_balance,
      projected_balance_cents: calculate_projected_balance
    )
  end

  private

  def calculate_confirmed_balance
    TransferQuery.confirmed.received(*ledger.users).sum(:amount_cents) -
      TransferQuery.confirmed.sent(*ledger.users).sum(:amount_cents)
  end

  def calculate_projected_balance
    TransferQuery.published.received(*ledger.users).sum(:amount_cents) -
      TransferQuery.published.sent(*ledger.users).sum(:amount_cents)
  end
end
