class UserQuery < BaseQuery
  def self.email_address(email_address)
    new
      .relation
      .email_address(email_address)
      .first
  end

  module Scopes
    def email_address(email_address)
      joins('LEFT JOIN email_addresses e ON e.user_id = user.id')
        .where('e.address = ?', email_address)
    end
  end
end
