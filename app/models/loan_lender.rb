class LoanLender < TransferParticipant
  belongs_to :lender, class_name:   'User',
                      foreign_key:  :user_id
  belongs_to :loan, inverse_of: :lenders, foreign_key: 'participable_id',
                    foreign_type: 'participable_type'
end
