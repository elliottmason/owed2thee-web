class LoanParticipant < TransferParticipant
  belongs_to :loan, foreign_key: 'transfer_id'
end
