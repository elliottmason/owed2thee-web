class NotifyLoanCreatorForConfirmation < ApplicationService
  attr_reader :loan

  delegate :creator, to: :loan

  def initialize(loan)
    @loan = loan
  end

  def allowed?
    !creator.encrypted_password?
  end

  def perform
    EmailAddressQuery.each_unconfirmed_for_user(creator) do |email_address|
      email_address_confirmation =
        CreateEmailAddressConfirmation.
        for(email_address).
        email_address_confirmation
      EmailAddressConfirmationMailer.
        email(email_address_confirmation).
        deliver_later
    end
  end
end
