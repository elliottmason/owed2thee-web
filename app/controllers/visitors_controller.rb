class VisitorsController < ApplicationController
  def index
    @loan = LoanForm.new
  end
end
