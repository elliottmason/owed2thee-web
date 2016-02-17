class LoanRequestPolicy < ApplicationPolicy
  alias_method :loan_request, :record

  def create?
    user
  end

  def show?
    user && user_is_creator?
  end

  private

  def user_is_creator?
    loan_request.creator == user
  end
end
