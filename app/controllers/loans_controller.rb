class LoansController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def new
    @loan = LoanForm.new
  end

  def create
    service = CreateLoan.with(current_user, params[:loan])

    if service.successful?
      sign_in_creator(service)
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

  private

  def sign_in_creator(service)
    if !user_signed_in? && service.unregistered_creator?
      sign_in(service.creator)
    else
      session[:user_email] = service.creator_email
    end
  end
end
