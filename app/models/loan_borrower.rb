class LoanBorrower < ActiveRecord::Base
  belongs_to :borrower, class_name: 'User', inverse_of: :loan_borrowers
  belongs_to :loan, inverse_of: false
end
