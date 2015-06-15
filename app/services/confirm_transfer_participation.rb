class ConfirmTransferParticipation < BaseService
  def initialize(user, participable)
    @participable = participable
    @user         = user
  end

  attr_reader :participable

  attr_reader :user

  def perform
    return unless participant

    @successful = participant.confirm!
  end

  private

  def participant
    @participant ||= TransferParticipant.where(participable:  participable,
                                               user:          user).first
  end
end
