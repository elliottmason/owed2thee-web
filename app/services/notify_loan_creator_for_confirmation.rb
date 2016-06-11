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
      CreateEmailAddressConfirmation.for(email_address)
    end
  end
end
