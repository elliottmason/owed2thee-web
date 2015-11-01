class LoansController < ApplicationController
  before_action :authenticate_user!, only: %i(show)
  before_action :retrieve_loan, except: %i(create new)

  def cancel
    service = CancelLoan.with(@loan)
    flash[:notice] = cancellation_notice if service.successful?
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
      establish_creator_session(creator: service.creator, loan: service.loan,
                                sign_in: service.unregistered_creator?)
      redirect_to(service.loan)
    else
      @loan = service.form
      render(:new)
    end
  end

  def dispute
    service = DisputeLoanParticipation.with(current_user, @loan)
    flash[:notice] = dispute_notice if service.successful?
    redirect_to([@loan])
  end

  def new
    @loan = LoanForm.new
  end

  def show
    @comment_form = CommentForm.new
  end

  private

  def cancellation_notice
    I18n.t('loans.notices.cancellation',
           amount_lent: @loan.amount.format,
           borrower:    @loan.borrower.first_name,
           lender:      @loan.lender.first_name)
  end

  def dispute_notice
    key = @loan.borrower == current_user ? :as_borrower : :as_lender
    I18n.t("loans.notices.dispute.#{key}",
           amount_lent:   @loan.amount.format,
           borrower:      @loan.borrower.first_name,
           lender:        @loan.creator.first_name)
  end

  def establish_creator_session(creator: nil, loan: nil, sign_in: false)
    if sign_in
      sign_in(creator)
    else
      session[:created_loan_id] = loan.id
      session[:email_address]   = creator.primary_email_address
    end
  end

  def retrieve_loan
    @loan = LoanQuery.uuid(params[:uuid])
    authorize(@loan)
  end
end
