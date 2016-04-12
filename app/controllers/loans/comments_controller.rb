module Loans
  class CommentsController < BaseController
    before_action :authenticate_user!
    before_action :retrieve_and_authorize_loan

    def create
      service = CreateComment.with(current_user, @loan, comment_params)

      if service.successful?
        redirect :back
      else
        @comment_form = service.form
        render [@loan]
      end
    end
  end
end
