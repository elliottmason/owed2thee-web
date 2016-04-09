class NotifyLoanCreator < ApplicationService
  attr_reader :loan

  delegate :creator, to: :loan

  def initialize(loan)
    @loan = loan
  end

  def allowed?
    !creator.confirmed? && creator.sign_in_count == 0
  end

  def perform
    EmailAddressConfirmationMailer.email(loan.creator).deliver_later
  end
end
