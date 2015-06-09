module Accounts
  class LoansController < BaseController
    before_filter :retrieve_loan

    def cancel
      CancelLoan.with(current_user, @loan)

      redirect_to([@loan])
    end

    def confirm
      ConfirmLoanParticipation.with(current_user, @loan)

      redirect_to([@loan])
    end

    def dispute
      DisputeLoanParticipation.with(current_user, @loan)

      redirect_to([@loan])
    end

    private

    def retrieve_loan
      @loan = Loan.find(params[:id])
      authorize(@loan)
    end
  end
end
