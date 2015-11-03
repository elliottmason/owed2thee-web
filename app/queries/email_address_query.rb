class EmailAddressQuery < BaseQuery
  def initialize(relation = EmailAddress.all)
    super(relation)
  end

  def self.for_transfer_participant(transfer, user)
    return user.email_addresses.first if transfer.creator_id == user.id

    new
      .relation
      .transfer(transfer)
      .user(user)
      .first
  end

  module Scopes
    def transfer(transfer)
      joins('LEFT JOIN transfer_email_addresses tea ' \
            'ON tea.email_address_id = email_addresses.id')
        .where('tea.transfer_id' => transfer.id)
    end

    def user(user)
      where(user: user)
    end
  end
end
