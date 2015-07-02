class VisitorsController < ApplicationController
  def index
    @loan_form = LoanForm.new
  end
end
