module Loans
  class CommentsController < BaseController
    before_action :authenticate_user!
    before_action :retrieve_and_authorize_loan

    def create
      service = CreateComment.with(current_user, @loan, params[:comment])

      if service.successful?
        redirect_to service.comment.commentable
      else
        render 'loans/show', locals: {
          comment_form: service.form,
          loan:         LoanPresenter.new(@loan)
        }
      end
    end
  end
end
