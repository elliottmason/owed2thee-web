class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # def create?
  #   false
  # end
  #
  # def destroy?
  #   false
  # end
  #
  # def edit?
  #   update?
  # end
  #
  # def index?
  #   false
  # end

  def new?
    create?
  end

  # def scope
  #   Pundit.policy_scope!(user, record.class)
  # end

  # def show?
  #   scope.where(id: record.id).exists?
  # end
  #
  # def update?
  #   false
  # end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope = nil)
      @user = user
      @scope = scope
    end
  end
end
