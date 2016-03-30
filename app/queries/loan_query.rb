class LoanQuery < ApplicationQuery
  def initialize(relation = Loan.all)
    super
  end

  def self.for_user(user)
    new.relation.
      published.
      user(user).
      order('transfers.created_at DESC')
  end

  def self.uuid!(uuid)
    Loan.where(uuid: uuid).first!
  end

  module Scopes
    def published
      in_state(:published)
    end

    def user(user)
      where(
        'recipient_id = ? OR creator_id = ? OR sender_id = ?',
        *([user] * 3)
      )
    end
  end
end
