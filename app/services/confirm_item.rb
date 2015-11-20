class ConfirmItem < ChangeState
  def initialize(item, *args)
    super(item, :confirm, *args)
  end
end
