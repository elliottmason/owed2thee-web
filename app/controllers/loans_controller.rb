class LoansController < ApplicationController
  def new
    @loan = LoanForm.new
  end

  def create
    creator = CreateLoan.with(current_user, params[:loan])

    if creator.successful?
      if !user_signed_in? && creator.user.unconfirmed?
        sign_in(creator.user)
      elsif !user_signed_in? && creator.user.confirmed?
        redirect_to(:new_session_path)
      end
      redirect_to(creator.loan)
    else
      @loan = creator.form
      render(:new)
    end
  end

  def show
    @loan = Loan.find(params[:id])
    authorize @loan
  end
end
