# Payments are made toward a User and applied toward relevant Loans through
# LoanPayments
class Payment < Transfer
  belongs_to :payer,  class_name: 'User',  foreign_key: 'sender_id'
  belongs_to :payee,  class_name: 'User',  foreign_key: 'recipient_id'

  has_many :loan_payments
  has_many :loans, through: :loan_payments
end
