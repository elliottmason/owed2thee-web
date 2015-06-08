class PublicityTransition < Transition
  belongs_to :publishable, polymorphic: true
end
