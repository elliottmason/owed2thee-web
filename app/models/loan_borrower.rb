class LoanBorrower < LoanParticipant
  belongs_to :borrower, class_name:   'User',
                        foreign_key:  'user_id'
end
