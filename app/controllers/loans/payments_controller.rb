module Loans
  class PaymentsController < BaseController
    before_action :authenticate_user!
    before_action :retrieve_and_authorize_loan

    def create
      service = CreatePaymentForLoan.with(current_user, @loan, params[:payment])

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
  end
end
