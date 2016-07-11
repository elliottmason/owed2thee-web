# When a User confirms participation in a Loan, we create UserContact records
# for the other participants pointing back to the confirming User.
class CreateUserContactsForTransferParticipant < ApplicationService
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
    create_user_contacts
    @successful = true
  end

  private

  def create_user_contacts
    recipients.map do |recipient|
      create_user_contact_for_contact(recipient)
      create_user_contact_for_recipient(recipient)
    end
  end

  def create_user_contact_for_contact(recipient)
    UserContactQuery.between(contact: recipient, owner: contact).
      first_or_create!(
        fallback_display_name: transfer.contact_name,
        source:                transfer
      )
  end

  def create_user_contact_for_recipient(recipient)
    UserContactQuery.between(contact: contact, owner: recipient).
      first_or_create!(
        fallback_display_name: contact.primary_email_address.address,
        source:                transfer
      )
  end
end
