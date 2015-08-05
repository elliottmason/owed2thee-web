class LoansController < ApplicationController
  before_action :authenticate_user!, only: %i(show)
  before_filter :retrieve_loan, except: %i(create new)

  def cancel
    service = CancelLoan.with(@loan)
    flash[:notice] = '' if service.successful?
    redirect_to([@loan])
  end

  def confirm
    service = ConfirmLoanParticipation.with(current_user, @loan)
    flash[:notice] = '' if service.successful?
    redirect_to([@loan])
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

  def dispute
    service = DisputeLoanParticipation.with(current_user, @loan)
    flash[:notice] = '' if service.successful?
    redirect_to([@loan])
  end

  def new
    @loan = LoanForm.new
  end

  def show
    @comment_form = CommentForm.new
  end

  private

  def retrieve_loan
    @loan = LoanQuery.uuid(params[:uuid])
    authorize(@loan)
  end

  def sign_in_creator(service)
    if !user_signed_in? && service.unregistered_creator?
      sign_in(service.creator)
    else
      session[:created_loan_id] = service.loan.id
      session[:email_address]   = service.creator_email_address
    end
  end
end
