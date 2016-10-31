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

  def self.unconfirmed_for_user(user)
    new.relation.
      unconfirmed.
      user(user)
  end

  module Scopes
    def address(address)
      where(address: address)
    end

    def unconfirmed
      not_in_state(:confirmed)
    end

    def user(user)
      where(user: user)
    end
  end
end
