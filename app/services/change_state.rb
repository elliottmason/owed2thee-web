class ChangeState < BaseService
  include Wisper::Publisher

  attr_reader :force
  attr_reader :item
  attr_reader :to_state

  def initialize(item, to_state, force = false)
    @force    = force
    @item     = item
    @to_state = to_state
  end

  def allowed?
    true
  end

  alias_method :force?, :force

  def perform
    return unless allowed? || force?

    @successful = item.send(:"#{to_state}!")

    broadcast_to_listeners if successful?
  end

  private

  def broadcast_to_listeners
  end
end

class ConfirmItem < ChangeState
  def initialize(item, *args)
    super(item, :confirm, *args)
  end
end

class PublishItem < ChangeState
  def initialize(item, *args)
    super(item, :publish, *args)
  end
end
