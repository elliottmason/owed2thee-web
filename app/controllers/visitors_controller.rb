class VisitorsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    redirect_to(:loans) && return if user_signed_in?

    @loan = LoanForm.new
  end
end
