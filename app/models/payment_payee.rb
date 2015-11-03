class PaymentPayee < TransferParticipant
  belongs_to :payee, foreign_key: 'user_id'
  belongs_to :payment, foreign_key: 'transfer_id'
end
