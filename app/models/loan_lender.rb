class LoanLender < LoanParticipant
  belongs_to :lender, class_name:   'User',
                      foreign_key:  :user_id
end
