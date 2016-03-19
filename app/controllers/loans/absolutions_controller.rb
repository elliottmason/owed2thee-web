module Loans
  class AbsolutionsController < BaseController
    def create
      retrieve_and_authorize_loan
      AbsolveLoan.with(@loan, current_user)
      redirect_to(@loan)
    end
  end
end
