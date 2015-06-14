class Payment < Transfer
  has_many :payment_payees
  has_many :payees, source: :user, through: :payment_payees
  has_many :payment_payers
  has_many :payers, source: :user, through: :payment_payers

  validates :payers,  exclusion:  { in: :lenders },
                      presence:   true
end
