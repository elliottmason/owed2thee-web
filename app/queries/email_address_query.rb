class EmailAddressQuery < BaseQuery
  def initialize(relation = EmailAddress.all)
    super(relation)
  end

  def self.address(*args)
    new
      .relation
      .address(*args)
      .first
  end

  def self.for_transfer_participant(transfer, user)
    return user.primary_email_address if transfer.creator_id == user.id

    new
      .relation
      .transfer(transfer)
      .user(user)
      .first
  end

  module Scopes
    def address(address)
      where(address: address)
    end

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
