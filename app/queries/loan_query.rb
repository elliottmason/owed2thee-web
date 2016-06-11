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

  def self.most_recent_incomplete_for_user(user)
    most_recent_unpublished_for_creator(user) ||
      most_recent_unconfirmed_for_borrower(user)
  end

  def self.most_recent_unconfirmed_for_borrower(user)
    new.relation.
      unconfirmed.
      borrower(user).
      most_recent.
      first
  end

  def self.most_recent_unpublished_for_creator(user)
    new.relation.
      unpublished.
      creator(user).
      most_recent.
      first
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

    def most_recent
      order('transfers.created_at DESC')
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
