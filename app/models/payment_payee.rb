class PaymentPayee < TransferParticipant
  belongs_to :payee,  foreign_key:  'send_id',
                      foreign_type: 'sender_type'

  belongs_to :payment,  foreign_key:  'participable_id',
                        foreign_type: 'participable_type'
end
