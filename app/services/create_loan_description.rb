class CreateLoanDescription < ApplicationService
  attr_reader :commenter
  attr_reader :loan
  attr_reader :loan_description

  def initialize(commenter, loan, params)
    @commenter  = commenter
    @loan       = loan
    @params     = params
  end

  def allowed?
    form.valid?
  end

  def form
    @form ||= LoanDescriptionForm.new(@params.merge(loan: loan))
  end

  def perform
    create_loan_description
    @successful = loan_description.persisted?
  end

  private

  def create_loan_description
    @loan_description ||= LoanDescription.create(@form.attributes) do |l|
      l.commenter = commenter
    end
  end
end
