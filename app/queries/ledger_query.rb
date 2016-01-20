class LedgerQuery < ApplicationQuery
  def initialize(relation = Ledger.all)
    super
  end

  def self.between(user_a, user_b)
    new
      .relation
      .between(user_a, user_b)
  end

  def self.between!(*args)
    between(*args).first
  end

  module Scopes
    def between(user_a, user_b)
      where(user_a: [user_a, user_b], user_b: [user_a, user_b])
    end
  end
end
