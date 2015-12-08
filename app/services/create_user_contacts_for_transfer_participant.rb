# When a User confirms participation in a Loan, we create UserContact records
# for the other participants pointing back to the confirming User.
class CreateUserContactsForTransferParticipant < BaseService
  attr_reader :contact
  attr_reader :transfer

  def initialize(transfer, contact)
    @contact  = contact
    @transfer = transfer
  end

  def recipients
    @recipients ||=
      [transfer.creator, transfer.recipient, transfer.sender] - [contact]
  end

  def perform
    @successful = true if create_user_contacts
  end

  private

  def create_user_contacts
    recipients.map do |recipient|
      UserContactQuery.between(recipient, contact).first_or_create! do |contact|
        contact.source = transfer
      end
    end
  end
end
