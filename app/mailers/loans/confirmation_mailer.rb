module Loans
  class ConfirmationMailer < BaseMailer
    private

    def presenter
      @presenter ||= Loans::ConfirmationMailerPresenter.new(loan, recipient)
    end
  end
end
