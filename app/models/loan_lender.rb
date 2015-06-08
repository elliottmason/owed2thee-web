class LoanLender < LoanParticipant
  belongs_to :lender, class_name:   'User',
                      foreign_key:  :user_id,
                      inverse_of:   :loan_lenders
end
