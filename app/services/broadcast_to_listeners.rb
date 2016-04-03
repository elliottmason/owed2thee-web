module BroadcastToListeners
  def self.included(base)
    base.class_eval do
      include Wisper::Publisher

      set_callback :perform, :after do
        broadcast_to_listeners if successful?
      end
    end
  end

  def broadcast_to_listeners
  end
end
