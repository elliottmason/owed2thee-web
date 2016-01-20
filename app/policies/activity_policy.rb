class ActivityPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  class Scope < Scope
    def resolve
      ActivityQuery.for_user(user)
    end
  end
end
