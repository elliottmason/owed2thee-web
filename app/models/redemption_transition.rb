class RedemptionTransition < Transition
  belongs_to :redeemable, foreign_key:  'transitional_id',
                          foreign_type: 'transitional_type',
                          polymorphic:  true
end
