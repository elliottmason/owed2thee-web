module BroadcastToListeners
  def self.included(base)
    base.class_eval do
      include Wisper::Publisher

      after_perform :broadcast_to_listeners, if: :successful?
    end
  end

  def broadcast_to_listeners
  end
end
