class ConfirmTransferParticipation < BaseService
  attr_reader :transfer
  attr_reader :user

  def initialize(user, transfer)
    @transfer = transfer
    @user     = user
  end

  def perform
    return unless participant

    @successful = participant.confirm!
  end

  private

  def participant
    @participant ||= TransferParticipant.where(transfer:  transfer,
                                               user:      user).first
  end
end
