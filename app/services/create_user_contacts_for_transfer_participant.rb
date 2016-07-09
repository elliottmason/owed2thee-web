# When a User confirms participation in a Loan, we create UserContact records
# for the other participants pointing back to the confirming User.
class CreateUserContactsForTransferParticipant < ApplicationService
  attr_reader :contact
  attr_reader :transfer

  delegate :creator, :recipient, :sender, to: :transfer

  def initialize(transfer, contact)
    @contact  = contact
    @transfer = transfer
  end

  def recipients
    @recipients ||= [creator, recipient, sender] - [contact]
  end

  def perform
    create_user_contacts
    @successful = true
  end

  private

  def create_user_contacts
    recipients.map do |recipient|
      UserContactQuery.for(contact: contact, owner: recipient).
        first_or_create!(source: transfer).confirm!
      UserContactQuery.for(contact: recipient, owner: contact).first_or_create!(
        fallback_display_name: transfer.contact_name,
        source:                transfer
      )
    end
  end
end
