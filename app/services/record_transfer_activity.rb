class RecordTransferActivity < BaseService
  attr_reader :action
  attr_reader :activities
  attr_reader :transfer

  def initialize(transfer, action)
    @action   = action.to_sym
    @transfer = transfer
  end

  def owners
    @owners ||= [transfer.creator]
  end

  def perform
    owners.each do |owner|
      @activities = recipients.map do |recipient|
        transfer.create_activity(action:    action,
                                 owner:     owner,
                                 recipient: recipient)
      end
    end

    @successful = true
  end

  def recipients
    @recipients ||= transfer.participants
  end
end
