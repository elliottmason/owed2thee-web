class EmailAddressQuery < BaseQuery
  def initialize(relation = EmailAddress.all)
    super(relation)
  end

  def self.for_loan_participant(loan, user)
    new
      .relation
      .loan(loan)
      .user(user)
      .first
  end

  module Scopes
    def loan(loan)
      joins('LEFT JOIN transfer_email_addresses tea ' \
            'ON tea.email_address_id = email_addresses.id')
        .where('tea.transfer_id' => loan.id)
    end

    def user(user)
      where(user: user)
    end
  end
end
