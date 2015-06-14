class BaseService
  class << self
    def with(*args)
      new(*args).tap(&:perform)
    end
    alias_method :for, :with
  end

  def successful?
    @successful
  end
end
