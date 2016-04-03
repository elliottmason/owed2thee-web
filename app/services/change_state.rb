module ChangeState
  def self.included(base)
    base.include BroadcastToListeners
    base.class_eval do
      extend ClassMethods
    end
  end

  attr_reader :item
  attr_reader :user

  def allowed?
    item.present? # &&
      # transition.present? &&
      # policy_class.new(user, item).send(:"#{transition}?")
  end

  def initialize(item, user)
    @item = item
    @user = user
  end

  # def policy_class
  #   return @policy_class if defined?(@policy_class)
  #
  #   @policy_class =
  #     begin
  #       "#{item.class}Policy".constantize
  #     rescue NameError
  #       nil
  #     end
  # end

  def perform
    @successful = item.send(:"#{transition}!")
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
