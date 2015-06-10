module Accounts
  class LoansController < BaseController
    before_filter :retrieve_loan

    def cancel
      service = CancelLoan.with(@loan)
      flash[:notice] = I18n.t('controllers.application.cancel.flash.notice') \
        if service.successful?
      redirect_to([@loan])
    end

    def confirm
      service = ConfirmLoanParticipation.with(current_user, @loan)
      flash[:notice] = I18n.t('controllers.application.confirm.flash.notice') \
        if service.successful?
      redirect_to([@loan])
    end

    def dispute
      service = DisputeLoanParticipation.with(current_user, @loan)
      flash[:notice] = I18n.t('controllers.application.dispute.flash.notice') \
        if service.successful?
      redirect_to([@loan])
    end

    private

    def retrieve_loan
      @loan = Loan.find(params[:id])
      authorize(@loan)
    end
  end
end
