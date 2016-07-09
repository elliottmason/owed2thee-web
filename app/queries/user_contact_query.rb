class UserContactQuery < ApplicationQuery
  def initialize(relation = UserContact.all)
    super
  end

  def self.between(**args)
    new.relation.
      between(args)
  end

  def self.confirmed_for(*args)
    new.relation.
      confirmed.
      between(*args)
  end

  def self.first_confirmed_for(*args)
    confirmed_for(*args).first
  end

  def self.for(**args)
    between(**args)
  end

  module Scopes
    def between(contact:, owner:)
      where(contact: contact, owner: owner)
    end

    def confirmed
      in_state(:confirmed)
    end
  end
end
