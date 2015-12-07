class LoansController < ApplicationController
  before_action :authenticate_user!, only: %i(show)
  before_action :retrieve_loan, only: %i(cancel confirm dispute show)

  def cancel
    service = CancelLoan.with(@loan, current_user)
    flash[:notice] = cancellation_notice if service.successful?
    redirect_to([@loan])
  end

  def confirm
    service = ConfirmLoan.with(@loan, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to([@loan])
  end

  def create
    service = CreateLoan.with(current_user, params[:loan])

    if service.successful?
      establish_creator_session(creator:  service.creator,
                                loan:     service.loan,
                                sign_in:  service.unregistered_creator?)
      redirect_to(service.loan)
    else
      @loan = service.form
      render(:new)
    end
  end

  def dispute
    service = DisputeLoan.with(@loan, current_user)
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
    loan = LoanPresenter.new(@loan, current_user)
    I18n.t('loans.notices.cancellation',
           amount_lent: loan.amount_lent,
           borrowers:   loan.borrower,
           lenders:     loan.lender)
  end

  def confirmation_notice
  end

  def dispute_notice
    loan = LoanPresenter.new(@loan, current_user)
    I18n.t('loans.notices.dispute',
           amount_lent: loan.amount_lent,
           borrowers:   loan.borrower,
           creator:     loan.creator,
           lenders:     loan.lender)
  end

  def establish_creator_session(creator: nil, loan: nil, sign_in: false)
    if sign_in
      sign_in(creator)
    else
      session[:created_loan_id] = loan.id
      session[:email_address]   = creator.primary_email_address.address
    end
  end

  def retrieve_loan
    @loan = LoanQuery.uuid(params[:uuid])
    authorize(@loan)
  end
end
