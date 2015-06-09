class LoansController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def new
    @loan = LoanForm.new
  end

  def create
    service = CreateLoan.with(current_user, params[:loan])

    if service.successful?
      sign_in(service.creator) unless user_signed_in?
      session[:user_email] = service.creator_email \
        unless service.unconfirmed_creator?
      redirect_to(service.loan)
    else
      @loan = service.form
      render(:new)
    end
  end

  def show
    @loan = Loan.find(params[:id])
    authorize @loan
  end
end
