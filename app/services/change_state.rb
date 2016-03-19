module ChangeState
  def self.included(base)
    base.include BroadcastToListeners
    base.class_eval do
      extend ClassMethods
    end
  end

  attr_reader :force
  attr_reader :item

  def allowed?
    transition.present?
  end

  alias force? force

  def perform
    return unless force? || allowed?

    @successful = item.send(:"#{transition}!")
    super
  end

  def transition
    self.class.transition
  end

  module ClassMethods
    def transition(to_state = nil)
      return @transition unless to_state

      @transition ||= to_state.to_sym
    end
  end
end
