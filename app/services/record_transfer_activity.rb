class RecordTransferActivity < BaseService
  attr_reader :action
  attr_reader :activities
  attr_reader :transfer

  # def initialize(transfer, action)
  # def initialize(owner, transfer, action)
  def initialize(*args)
    @action   = (args[2] || args[1]).to_sym
    @owner    = args[0] if args[2]
    @transfer = args[2] ? args[1] : args[0]
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
