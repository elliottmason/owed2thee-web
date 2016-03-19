module Loans
  class BaseController < ApplicationController
    private

    def authorize_loan
      authorize(@loan || Loan)
    end

    def retrieve_loan
      @loan = LoanQuery.uuid!(params[:loan_uuid])
    end

    def retrieve_and_authorize_loan
      retrieve_loan
      authorize_loan
    end
  end
end
