module Loans
  class CommentsController < ApplicationController
    before_filter :retrieve_loan, only: %i(create)

    def create
      service = CreateComment.with(current_user, @loan, params[:comment])

      if service.successful?
        redirect_to(@loan)
      else
        @comment = service.form
        render(@loan)
      end
    end

    private

    def retrieve_loan
      @loan = LoanQuery.uuid(params[:loan_uuid])
      authorize(@loan, :comment?)
    end
  end
end
