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
    NotifyLoanParticipants.with(@loan)
  end

  private

  def sign_in_creator(service)
    return if user_signed_in?

    if service.creator.unconfirmed?
      sign_in(service.creator)
    else
      session[:created_loan_id] = service.loan.id
      session[:user_email] = service.creator_email
    end
  end
end
