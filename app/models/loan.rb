# Loan is a payable type of Transfer. The borrower is equivalent to the
# recipient and the lender is equivalent to the sender.
class Loan < Transfer
  belongs_to :borrower, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :lender,   class_name: 'User', foreign_key: 'sender_id'
  belongs_to :loan_request

  transitional :payment

  def obligor
    @obligor ||= creator == lender ? borrower : lender
  end
end
