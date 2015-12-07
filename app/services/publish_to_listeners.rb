module PublishToListeners
  def self.included(base)
    base.class_eval do
      extend ActiveModel::Callbacks
      extend ClassMethods

      define_model_callbacks :initialize, :perform, :success

      after_initialize :subscribe_to_listeners
      after_perform :broadcast_to_listeners, if: :successful?
    end
  end

  def broadcast_to_listeners
  end

  def listeners
    @listeners ||= self.class.listeners.clone
  end

  def subscribe_to_listeners
    listeners.each do |name|
      subscribe(name.constantize.new)
    end
  end

  module ClassMethods
    def subscribe(listener_name)
      listeners << listener_name
    end

    def listeners
      @listeners ||= []
    end
  end
end
