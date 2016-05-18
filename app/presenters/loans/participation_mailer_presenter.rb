module Loans
  class ParticipationMailerPresenter < BaseMailerPresenter
    def confirmation_path
      if recipient.confirmed?
        [loan]
      else
        [email_address_confirmation, :redemption]
      end
    end

    def loan_type
      creator_is_lender? ? 'loan' : 'debt'
    end

    def subject
      "[#{h.t('app.title')}] - Confirm or deny your loan with #{creator}"
    end

    def verb
      creator_is_lender? ? 'lent' : 'owe'
    end

    private

    def creator_is_lender?
      loan.creator == loan.lender
    end

    def email_address_confirmation
      @email_address_confirmation ||=
        EmailAddressConfirmationQuery.
        most_recent_email_address(loan.recipient.primary_email_address)
    end
  end
end
