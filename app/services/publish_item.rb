class PublishItem < BaseService
  include ChangeState

  def initialize(item, *args)
    super(item, :publish, *args)
  end
end
