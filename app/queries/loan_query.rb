class LoanQuery < ApplicationQuery
  def initialize(relation = Loan.all)
    super
  end

  def self.last_incomplete_for_user(user)
    LoanQuery.last_unpublished_for_creator(user) ||
      LoanQuery.last_unconfirmed_for_borrower(user)
  end

  def self.last_unpublished_for_creator(user)
    new.relation.
      unpublished.
      creator(user).
      order('transfers.created_at DESC').
      last
  end

  def self.last_unconfirmed_for_borrower(user)
    new.relation.
      unconfirmed.
      borrower(user).
      order('transfers.created_at DESC').
      last
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
    def borrower(user)
      where(recipient: user)
    end

    def creator(user)
      where(creator: user)
    end

    def published
      in_state(:published)
    end

    def unconfirmed
      not_in_state(:confirmed)
    end

    def unpublished
      not_in_state(:published)
    end

    def user(user)
      where(
        'recipient_id = ? OR creator_id = ? OR sender_id = ?',
        *([user] * 3)
      )
    end
  end
end
