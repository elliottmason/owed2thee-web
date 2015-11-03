# Users can have multiple EmailAddresses associated with one's account, which
# means that a submitted Transfer might reference a specific email address. For
# privacy purposes, we want to track the email address that was entered by the
# creator, to avoid revealing a user's alternate email addresses. This
# necessitates the complexity of this join table
class TransferEmailAddress < ActiveRecord::Base
  belongs_to :email_address
  belongs_to :transfer

  def self.create_with(transfer, email_address)
    create do |t|
      t.email_address = email_address
      t.transfer      = transfer
    end
  end
end
