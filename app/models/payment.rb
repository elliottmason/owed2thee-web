# Payments are applied toward unpaid Loans. Similar to Loans, they must be
# confirmed by the creator to be published and visible, and must be confirmed
# by the PaymentPayees.
class Payment < Transfer
  belongs_to :payer,    foreign_key:  'sender_id',
                        foreign_type: 'sender_type',
                        polymorphic:  true
  belongs_to :payable,  foreign_key:  'recipient_id',
                        foreign_type: 'recipient_type',
                        polymorphic:  true
  has_many :payment_payees, as: :participable
  has_many :payees, source: :user, through: :payment_payees
  has_many :payment_payers, as: :participable
  has_many :payers, source: :user, through: :payment_payers

  validates :payers,  exclusion:  { in: :payees },
                      presence:   true
end
