class LoansController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_filter :retrieve_loan, except: %i(create new)

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
  end

  def cancel
    service = CancelLoan.with(@loan)
    flash[:notice] = I18n.t('controllers.application.cancel.flash.notice') \
      if service.successful?
    redirect_to([@loan])
  end

  def confirm
    service = ConfirmLoanParticipation.with(current_user, @loan)
    flash[:notice] = I18n.t('controllers.application.confirm.flash.notice') \
      if service.successful?
    redirect_to([@loan])
  end

  def dispute
    service = DisputeLoanParticipation.with(current_user, @loan)
    flash[:notice] = I18n.t('controllers.application.dispute.flash.notice') \
      if service.successful?
    redirect_to([@loan])
  end

  private

  def retrieve_loan
    @loan = Loan.find(params[:id])
    authorize(@loan)
  end

  def sign_in_creator(service)
    if !user_signed_in? && service.unregistered_creator?
      sign_in(service.creator)
    else
      session[:user_email] = service.creator_email
    end
  end
end
