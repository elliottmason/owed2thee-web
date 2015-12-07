# Loan is a payable type of Transfer. The borrower is equivalent to the
# recipient and the lender is equivalent to the sender.
#
# Payments are applied toward a Loan to satisfy its payment status, although
# the Loan can be absolved by the lender for any reason(s), which is
# equivalent.
class Loan < Transfer
  # has_many :through definitions must remain in this order until this issue is
  # resolved: https://github.com/rails/rails/issues/16139
  belongs_to :borrower, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :lender,   class_name: 'User', foreign_key: 'sender_id'

  transitional :payment
end
