class ConfirmLoan < BaseService
  include Wisper::Publisher

  attr_reader :loan

  def initialize(loan)
    @loan = loan

    subscribe(LoanListener.new)
    subscribe(LoanParticipationListener.new)
  end

  def perform
    @successful = @loan.confirm!

    broadcast_to_listeners if successful?
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_loan_successful, loan)
    loan.participants.each do |user|
      broadcast(:confirm_loan_participation_successful, user, loan)
    end
  end
end
