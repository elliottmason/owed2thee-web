class LoanBorrower < TransferParticipant
  belongs_to :borrower, class_name: 'User',
                        foreign_key: 'user_id'
  belongs_to :loan, inverse_of: :borrowers, foreign_key: 'participable_id',
                    foreign_type: 'participable_type'
end
