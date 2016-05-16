module Loans
  class ParticipationMailer < BaseMailer
    private

    def presenter
      @presenter ||= Loans::ParticipationMailerPresenter.new(loan, recipient)
    end
  end
end
