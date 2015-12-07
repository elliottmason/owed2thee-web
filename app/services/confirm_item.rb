class ConfirmItem < BaseService
  include ChangeState

  def initialize(item, *args)
    super(item, :confirm, *args)
  end
end
