class UserContactQuery < ApplicationQuery
  def initialize(relation = UserContact.all)
    super
  end

  def self.between(*args)
    new.relation.
      between(*args)
  end

  def self.confirmed_between(*args)
    between(*args).confirmed
  end

  def self.confirmed_between?(*args)
    confirmed_between(*args).exists?
  end

  def self.first_between(*args)
    between(*args).first
  end

  def self.for_source(*args)
    new.relation.
      for_source(*args)
  end

  def self.unconfirmed_for_source(*args)
    for_source(*args).unconfirmed
  end

  module Scopes
    def between(contact:, owner:)
      where(contact: contact, owner: owner)
    end

    def confirmed
      in_state(:confirmed)
    end

    def for_source(contact:, source:)
      where(contact: contact, source: source)
    end

    def unconfirmed
      in_state(:unconfirmed)
    end
  end
end
