class BaseService
  extend ActiveModel::Callbacks

  define_model_callbacks :initialize, :perform

  class << self
    def success(method_name)
      success_callbacks << method_name
    end

    def with(*args)
      new(*args).tap(&:perform)
    end
    alias_method :for, :with
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
