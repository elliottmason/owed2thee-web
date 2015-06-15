class PaymentPayee < TransferParticipant
  belongs_to :payee,  foreign_key:  'user_id'
  belongs_to :payment,  foreign_key:  'participable_id',
                        foreign_type: 'participable_type',
                        polymorphic:  true
end
