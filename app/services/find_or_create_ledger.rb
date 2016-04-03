class FindOrCreateLedger < ApplicationService
  attr_reader :ledger
  attr_reader :user_a
  attr_reader :user_b

  class << self
    alias between with
  end

  def initialize(user_a, user_b)
    @user_a = user_a
    @user_b = user_b
  end

  def perform
    # TODO: RecalculateLedger should accept an actual ledger
    find_or_create_ledger
    RecalculateLedger.with(user_a, user_b)
    @succesful = ledger.persisted?
  end

  private

  def find_or_create_ledger
    @ledger ||= LedgerQuery.between(user_a, user_b).
                first_or_create(user_a: user_a, user_b: user_b)
  end
end
