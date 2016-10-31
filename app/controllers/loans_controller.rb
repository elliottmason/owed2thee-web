class LoansController < ApplicationController
  before_action :authenticate_user!, only: %i(show)
  before_action :retrieve_loan, only: %i(cancel confirm dispute publish show)
  before_action :authorize_loan

  helper_method :description_form
  helper_method :loan

  def cancel
    service = CancelLoan.with(@loan, current_user)
    flash[:notice] = cancellation_notice if service.successful?
    redirect_to(@loan)
  end

  def confirm
    service = ConfirmLoan.with(@loan, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to(@loan)
  end

  def create
    service = CreateLoan.with(current_user, params[:loan])

    flash_message_for_create(service.successful?)

    if service.successful?
      establish_creator_session(service)
      redirect_to(service.loan)
    else
      @loan = service.form
      render(:new)
    end
  end

  def dispute
    service = DisputeLoan.with(@loan, current_user)
    flash[:success] = dispute_notice if service.successful?
    redirect_to(@loan)
  end

  def new
    @loan = LoanForm.new
  end

  def show
  end

  def publish
    service = PublishLoan.with(@loan, current_user)
    flash[:success] = confirmation_notice if service.successful?
    redirect_to([@loan])
  end

  private

  def authorize_loan
    authorize(@loan || Loan)
  end

  def cancellation_notice
    I18n.t('loans.notices.cancellation',
           amount_lent: loan.amount_lent,
           borrower:    loan.borrower,
           lender:      loan.lender(possessive: true))
  end

  def description_form
    @description_form ||= LoanDescriptionForm.new(loan: @loan)
  end

  def confirmation_notice
    I18n.t('loans.notices.confirmation',
           borrower:    loan.borrower,
           lender:      loan.lender(possessive: true))
  end

  def dispute_notice
    I18n.t('loans.notices.dispute',
           amount_lent: loan.amount_lent,
           borrower:    loan.borrower,
           creator:     loan.creator,
           lender:      loan.lender(possessive: true))
  end

  def establish_creator_session(service)
    # sign in the creator only if they used an unknown email address
    if service.unregistered_creator?
      sign_in(service.creator)
    else
      session[:email_address] = service.creator_email_address
    end
  end

  def flash_message_for_create(successful = false)
    if successful
      flash[:success] = t('loans.notices.creation')
    else
      flash[:error] = t('loans.notices.failure')
    end
  end

  def loan
    @presented_loan ||= LoanPresenter.new(@loan, current_user)
  end

  def retrieve_loan
    @loan = LoanQuery.uuid!(params[:uuid])
  end
end
