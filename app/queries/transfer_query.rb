class TransferQuery < ApplicationQuery
  def initialize(relation = Transfer.all)
    super
  end

  def self.between(user_a, user_b)
    new.relation.where(recipient: [user_a, user_b], sender: [user_a, user_b])
  end

  def self.confirmed_between(*args)
    between(*args).confirmed
  end

  def self.confirmed
    new.relation.
      confirmed
  end

  def self.unconfirmed_between(*args)
    between(*args).unconfirmed
  end

  def self.published
    new.relation.
      published
  end

  module Scopes
    def confirmed
      in_state(:confirmed)
    end

    def published
      in_state(:published)
    end

    def received(recipient, sender)
      where(recipient: recipient, sender: sender)
    end

    def sent(sender, recipient)
      where(recipient: recipient, sender: sender)
    end

    def unconfirmed
      not_in_state(:confirmed)
    end
  end
end
