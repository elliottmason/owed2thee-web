# Loan is a payable type of Transfer. The borrower is equivalent to the
# recipient and the lender is equivalent to the sender.
class Loan < Transfer
  belongs_to :borrower, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :lender,   class_name: 'User', foreign_key: 'sender_id'
  belongs_to :loan_request

  has_many :loan_payments
  has_many :payments, through: :loan_payments

  before_create :set_balance

  def obligor
    @obligor ||= creator == lender ? borrower : lender
  end

  private

  def set_balance
    self[:balance_cents] = self[:amount_cents]
  end
end
