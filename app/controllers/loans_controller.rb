class LoansController < ApplicationController
  def new
    @loan = LoanForm.new
  end

  def create
    creator = CreateLoan.with(current_user, params[:loan])

    if creator.successful?
      redirect_to creator.loan
    else
      @loan = creator.form
      render :new
    end
  end

  def show
    @loan = Loan.find(params[:id])
  end
end
