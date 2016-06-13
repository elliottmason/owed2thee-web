class NotifyLoanObligor < ApplicationService
  attr_reader :loan

  delegate :obligor, to: :loan

  def initialize(loan)
    @loan = loan
  end

  def perform
    if obligor.unconfirmed?
      CreateEmailAddressConfirmation.for(obligor.primary_email_address)
    end

    Loans::ParticipationMailer.email(loan, obligor).deliver_later
  end
end
