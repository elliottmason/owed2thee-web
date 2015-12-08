class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_payment,  only: %i(confirm publish show)
  before_action :retrieve_payee,    only: %i(create new)

  def confirm
    service = ConfirmPayment.with(@payment, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to(@payment)
  end

  def create
    service = CreatePayment.with(current_user, @payee, params[:payment])

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

  def publish
    service = PublishPayment.with(@payment, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to(@payment)
  end

  def show
    retrieve_payment
  end

  private

  def confirmation_notice
    payment = PaymentPresenter.new(@payment, current_user)
    flash[:notice] = I18n.t('payments.notices.confirmation',
                            amount_paid:  payment.amount_paid,
                            payee:        payment.payee,
                            payer:        payment.payer)
  end

  def retrieve_payee
    @payee = UserQuery.uuid!(params[:user_uuid])
    authorize(@payee, :pay?)
  end

  def retrieve_payment
    @payment = Payment.where(uuid: params[:uuid]).first!
    authorize(@payment)
  end
end
