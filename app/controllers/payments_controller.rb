class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_loan, only: %i(create new)
  before_action :retrieve_payment, only: %i(confirm show)

  def confirm
    service = ConfirmPayment.with(@payment, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to(@payment)
  end

  def create
    service = CreatePayment.with(current_user, @loan, params[:payment])

    if service.successful?
      redirect_to(service.payment)
    else
      @payment_form = service.form
      render :new
    end
  end

  def new
    @payment_form = PaymentForm.new
  end

  def show
    retrieve_payment
  end

  private

  def confirmation_notice
    payment = PaymentPresenter.new(@payment, current_user)
    flash[:notice] = I18n.t('payments.notices.confirmation',
                            amount_lent:  payment.amount_lent,
                            amount_paid:  payment.amount_paid,
                            borrowers:    payment.borrowers,
                            lenders:      payment.lenders,
                            payers:       payment.payers)
  end

  def retrieve_loan
    @loan = LoanQuery.uuid(params[:loan_uuid])
    authorize(@loan, :pay?)
  end

  def retrieve_payment
    @payment = Payment.where(uuid: params[:uuid]).first!
    authorize(@payment)
  end
end
