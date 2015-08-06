class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :retrieve_loan, only: %i(create new)
  before_filter :retrieve_payment, only: %i(confirm show)

  def confirm
    service = ConfirmPaymentParticipation.with(current_user, @payment)
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
    user, key = if @payment.payer == current_user
                  [@payment.payable.lender.first_name, :as_payer]
                else
                  [@payment.payer.first_name, :as_payee]
                end
    type = key == :as_payer ? :payee : :payer

    flash[:notice] = I18n.t("payments.notices.confirmation.#{key}",
                            amount_lent: @payment.payable.amount.format,
                            amount_paid: @payment.amount.format,
                            borrower: user,
                            lender:   user,
                            type =>   user)
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
