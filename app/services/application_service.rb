class ApplicationService
  extend ActiveModel::Callbacks

  define_model_callbacks :initialize, :perform

  class << self
    def with(*args)
      new(*args).tap(&:perform)
    end
    alias for with
  end

  def initialize(*_args)
    run_callbacks(:initialize) { true }
  end

  def perform
    run_callbacks(:perform) { true }
  end

  def successful?
    @successful || false
  end
end
