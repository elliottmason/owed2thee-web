class RecordTransferActivity < ApplicationService
  attr_reader :action
  attr_reader :activities
  attr_reader :transfer

  def initialize(transfer, action, owner = nil)
    @action   = action
    @owner    = owner
    @transfer = transfer
  end

  def owner
    @owner ||= transfer.creator
  end

  def perform
    @activities = recipients.map do |recipient|
      transfer.create_activity(action:    action,
                               owner:     owner,
                               recipient: recipient)
    end

    @successful = true
  end

  def recipients
    @recipients ||= [transfer.recipient, transfer.sender]
  end
end
