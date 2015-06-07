class BaseService
  class << self
    def with(*args)
      new(*args).tap(&:perform)
    end
    alias_method :for, :with
  end

  def perform
  end
end
