module Loans
  class DescriptionsController < BaseController
    before_action :authenticate_user!
    before_action :retrieve_and_authorize_loan

    def create
      service = CreateLoanDescription.
                with(current_user, @loan, params[:loan_description])

      if service.successful?
        redirect_to @loan
      else
        render 'loans/show', locals: {
          description_form: service.form,
          loan:             LoanPresenter.new(@loan)
        }
      end
    end
  end
end
