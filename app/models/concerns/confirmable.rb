# TODO: extract the rest of these methods into Transitional
module Confirmable
  def self.included(base)
    base.class_eval do
      include Transitional
      extend ClassMethods

      has_many :confirmation_transitions, as: :transitional
    end
  end

  def confirm!
    confirmation.transition_to(:confirmed)
  end

  def confirmation
    @confirmation ||= ConfirmationStateMachine.new(
      self,
      association_name: :confirmation_transitions,
      transition_class: ConfirmationTransition
    )
  end

  def dispute!
    confirmation.transition_to(:disputed)
  end

  ConfirmationStateMachine.states.each do |state|
    define_method(:"#{state}?") do
      confirmation.current_state == state
    end
  end

  module ClassMethods
    def initial_state
      super << ConfirmationStateMachine.initial_state
    end
  end
end
