class DebtQuery < ApplicationQuery
  def initialize(relation = Loan.all)
    super
  end

  def self.first_unconfirmed_for_user!(user)
    new.relation.
      unconfirmed.
      for_recipient(user).
      first!
  end

  def self.unconfirmed_count_for_user!(user)
    new.relation.
      unconfirmed.
      for_recipient(user).
      count
  end

  module Scopes
    def for_recipient(user)
      where(recipient: user)
    end

    def unconfirmed
      not_in_state(:confirmed)
    end
  end
end
