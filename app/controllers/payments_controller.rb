class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :retrieve_loan, only: %i(create new)
  before_filter :retrieve_payment, only: %i(confirm show)

  def confirm
    service = ConfirmPaymentParticipation.with(current_user, @payment)
    flash[:notice] = I18n.t('controllers.application.confirm.flash.notice') \
      if service.successful?
    redirect_to(@payment)
  end

  def create
    service = CreatePayment.with(current_user, @loan, params[:payment])

    if service.successful?
      redirect_to(service.payment)
    else
      @payment = service.form
      render :new
    end
  end

  def new
    @payment = PaymentForm.new
  end

  def show
    retrieve_payment
  end

  private

  def retrieve_loan
    @loan = Loan.find(params[:loan_id])
    authorize(@loan, :pay?)
  end

  def retrieve_payment
    @payment = Payment.find(params[:id])
    authorize(@payment)
  end
end
