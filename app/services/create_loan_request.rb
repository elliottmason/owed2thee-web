class CreateLoanRequest < ApplicationService
  attr_reader :creator
  attr_reader :loan_request
  attr_reader :params

  def initialize(creator, params)
    @creator  = creator
    @params   = params
  end

  def form
    @form ||= LoanRequestForm.new(params)
  end

  def perform
    @loan_request = LoanRequest.create(form.attributes) do |l|
      l.creator = creator
    end
  end

  def successful?
    loan_request && loan_request.persisted?
  end
end
