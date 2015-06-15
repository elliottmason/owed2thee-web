class ConfirmLoanParticipation < BaseService
  include Wisper::Publisher

  def initialize(user, loan)
    @loan = loan
    @user = user

    subscribe(CreateLedgersForLoanParticipant.new)
    subscribe(PublishLoan.new)
  end

  attr_reader :loan

  def loan_participant
    @loan_participant ||= LoanParticipant \
                          .in_state(:unconfirmed) \
                          .where(loan: loan, user: user) \
                          .first
  end

  def perform
    return unless loan_participant

    @successful = loan_participant.confirm!

    broadcast(:confirm_loan_participation_successful, user, loan) \
      if successful?
  end

  def successful?
    @successful
  end

  attr_reader :user
end
