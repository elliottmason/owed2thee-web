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
