class BasePresenter < Burgundy::Item
  attr_reader :viewer

  def initialize(item, viewer = nil)
    super(item)
    @viewer = viewer
  end
end
