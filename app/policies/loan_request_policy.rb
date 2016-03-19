class LoanRequestPolicy < ApplicationPolicy
  def create?
    user
  end

  alias loan_request record

  def show?
    user && user_is_creator?
  end

  private

  def user_is_creator?
    loan_request.creator == user
  end
end
