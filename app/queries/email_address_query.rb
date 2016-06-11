class EmailAddressQuery < ApplicationQuery
  def initialize(relation = EmailAddress.all)
    super(relation)
  end

  def self.address(email_address)
    new.relation.
      address(email_address)
  end

  def self.address!(*args)
    address(*args).first
  end

  def self.each_unconfirmed_for_user(user)
    unconfirmed_for_user(user).each { |u| yield(u) }
  end

  def self.for_transfer_participant(transfer, user)
    new.relation.
      transfer(transfer).
      user(user)
  end

  def self.for_transfer_participant!(transfer, user)
    return user.primary_email_address if transfer.creator_id == user.id

    for_transfer_participant(transfer, user).first
  end

  def self.unconfirmed_for_user(user)
    new.relation.
      unconfirmed.
      user(user)
  end

  module Scopes
    def address(address)
      where(address: address)
    end

    def transfer(transfer)
      joins('LEFT JOIN transfer_email_addresses tea ' \
            'ON tea.email_address_id = email_addresses.id').
        where('tea.transfer_id' => transfer.id)
    end

    def unconfirmed
      not_in_state(:confirmed)
    end

    def user(user)
      where(user: user)
    end
  end
end
