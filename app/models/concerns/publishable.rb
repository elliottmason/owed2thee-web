module Publishable
  def self.included(base)
    base.class_eval do
      include Transitional
      extend ClassMethods

      has_many :publicity_transitions, as: :transitional
    end
  end

  def publicity
    @publicity ||= PublicityStateMachine.new(
      self,
      association_name: :transitions,
      transition_class: PublicityTransition
    )
  end

  PublicityStateMachine.states.each do |state|
    define_method(:"#{state}?") do
      publicity.current_state == state
    end
  end

  module ClassMethods
    def initial_state
      super << :unpublished
    end
  end
end
