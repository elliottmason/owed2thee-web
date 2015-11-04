# When a User confirms participation in a Loan, we create UserContact records
# for the other participants pointing back to the confirming User.
class CreateUserContactsForTransferParticipant < BaseService
  attr_reader :contact
  attr_reader :transfer

  def initialize(contact, transfer)
    @contact  = contact
    @transfer = transfer
  end

  def recipients
    @recipients ||= transfer.participants - [contact]
  end

  def perform
    ActiveRecord::Base.transaction do
      begin
        create_user_contacts
        @successful = true
      rescue ActiveRecord::RecordInvalid
        @successful = false
        raise ActiveRecord::Rollback
      end
    end

    @successful = true
  end

  private

  def create_user_contacts
    recipients.map do |recipient|
      UserContactQuery.between(recipient, contact).first_or_create do |contact|
        contact.source = transfer
      end
    end
  end
end
