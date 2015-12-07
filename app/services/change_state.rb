module ChangeState
  def self.included(base)
    base.class_eval do
      include PublishToListeners
      extend ClassMethods
    end
  end

  attr_reader :force
  attr_reader :item

  def allowed?
    transition.present?
  end

  alias_method :force?, :force

  def perform
    return unless force? || allowed?

    puts 'changing state of: ' + item.inspect + ' to ' + transition.inspect

    @successful = item.send(:"#{transition}!")

    puts @successful
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
