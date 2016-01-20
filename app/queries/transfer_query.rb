class TransferQuery < ApplicationQuery
  def initialize(relation = Transfer.all)
    super
  end

  def self.confirmed
    new
      .relation
      .confirmed
  end

  def self.published
    new
      .relation
      .published
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
  end
end
