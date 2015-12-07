class BaseService
  class << self
    def success(method_name)
      success_callbacks << method_name
    end

    def with(*args)
      new(*args).tap(&:perform)
    end
    alias_method :for, :with
  end

  def successful?
    @successful || false
  end
end
