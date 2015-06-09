class ConfirmLoanParticipation < BaseService
  include Wisper::Publisher

  def initialize(user, loan)
    @loan = loan
    @user = user

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

    loan_participant.confirm!

    broadcast(:confirm_loan_participation_successful, loan_participant) \
      if successful?
  end

  def successful?
    loan_participant.confirmed?
  end

  attr_reader :user

  def user_sign_in_successful(user, loan_id)
    loan = Loan.find(loan_id)
    self.class.with(loan: loan, user: user)
  end
end
