class TransferParticipantQuery < BaseQuery
  def initialize(relation = TransferParticipant.all)
    super
  end

  def self.confirmed_creator_for(loan)
    new
      .relation
      .confirmed_creator_for(loan)
  end

  module Scopes
    def confirmed_creator_for(loan)
      in_state(:confirmed).where(user_id: loan.creator_id)
    end
  end
end
