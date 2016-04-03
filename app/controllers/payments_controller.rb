class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_payment,  only: %i(confirm publish show)
  before_action :retrieve_payee,    only: %i(create new)

  def confirm
    service = ConfirmPayment.with(@payment, current_user)
    flash[:notice] = confirmation_notice if service.successful?
    redirect_to(@payment)
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

  def retrieve_payment
    @payment = Payment.where(uuid: params[:uuid]).first!
    authorize(@payment)
  end
end
