class UserQuery < ApplicationQuery
  def initialize(relation = User.all)
    super
  end

  def self.email_address(email_address)
    new.relation.
      email_address(email_address).
      first
  end

  module Scopes
    def email_address(email_address)
      joins('LEFT JOIN email_addresses e ON e.user_id = users.id').
        where('e.address = ?', email_address)
    end
  end
end
