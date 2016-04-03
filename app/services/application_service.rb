class ApplicationService
  include ActiveSupport::Callbacks

  define_callbacks :perform

  class << self
    def with(*args)
      new(*args).tap(&:_perform)
    end
    alias for with
  end

  def _perform
    run_callbacks :perform do
      return unless allowed?
      perform
    end
    after_failure unless successful?
  end

  def after_failure
  end

  def allowed?
    true
  end

  def initialize(*_args)
  end

  def perform
  end

  def successful?
    @successful || false
  end
end
