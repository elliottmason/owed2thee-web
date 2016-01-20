class UserContactQuery < ApplicationQuery
  def initialize(relation = UserContact.all)
    super
  end

  def self.between(user, contact)
    new
      .relation
      .between(user, contact)
  end

  module Scopes
    def between(user, contact)
      where(contact: contact, user: user)
    end
  end
end
