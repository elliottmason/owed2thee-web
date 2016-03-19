class LoanRequestsController < ApplicationController
  before_action :authenticate_user!
  after_action :authorize_loan_request

  def create
    service = CreateLoanRequest.with(current_user, params[:loan_request])

    flash_message_for_create(service.successful?)

    if service.successful?
      redirect_to(service.loan_request)
    else
      @loan_request_form = service.form
      render(:new)
    end
  end

  def index
    @loan_requests = policy_scope(LoanRequest).page(index_params.page)
  end

  def new
    @loan_request_form = LoanRequestForm.new
  end

  def show
    retrieve_loan_request
  end

  private

  def authorize_loan_request
    authorize(@loan_request || LoanRequest)
  end

  def flash_message_for_create(successful = false)
    if successful
      flash[:success] = t('loan_requests.notices.creation')
    else
      flash[:error] = t('loan_requests.errors.creation')
    end
  end

  def index_params
    @index_params || LoanRequestParams.new(params)
  end

  def retrieve_loan_request
    @loan_request = LoanRequestQuery.uuid!(params[:uuid])
  end
end
