class ConfirmationTransition < Transition
  belongs_to :confirmable, polymorphic:  true
end
