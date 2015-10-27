class FindOrCreateLedger < BaseService
  attr_reader :user_a
  attr_reader :user_b

  class << self
    alias_method :between, :with
  end

  def initialize(user_a, user_b)
    @user_a = user_a
    @user_b = user_b
  end

  def ledger
    @ledger ||= Ledger.between(user_a, user_b).first ||
                Ledger.create!(user_a: user_a, user_b: user_b)
  end

  def perform
    ledger.save if ledger.new_record?
    @succesful = ledger.persisted?
  end
end
