class PaymentTransition < Transition
  belongs_to :publishable,  foreign_key:  'transitional_id',
                            foreign_type: 'transitional_type',
                            polymorphic:  true
end
