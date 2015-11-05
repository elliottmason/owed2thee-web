class TransferParticipantQuery < BaseQuery
  def initialize(relation = TransferParticipant.all)
    super
  end

  def self.confirmed_creator_for(transfer)
    new
      .relation
      .confirmed_creator_for(transfer)
  end

  module Scopes
    def confirmed_creator_for(transfer)
      in_state(:confirmed).where(user_id: transfer.creator_id)
    end
  end
end
