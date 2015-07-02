class LoanParticipant < TransferParticipant
  belongs_to :loan, foreign_key:  'participable_id',
                    foreign_type: 'participable_type'
end
