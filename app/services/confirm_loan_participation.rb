class ConfirmLoanParticipation < BaseService
  include Wisper::Publisher

  def initialize(loan_id: nil, user: nil)
    @loan_id  = loan_id
    @user     = user

    subscribe(PublishLoan.new)
  end

  def loan_participant
    @loan_participant ||= LoanParticipant.where(
      loan_id:  @loan_id,
      user:     @user
    ).first
  end

  def perform
    loan_participant.confirm!
    broadcast(:confirm_loan_participation_successful, loan_participant) \
      if successful?
  end

  def successful?
    loan_participant.confirmed?
  end

  def user_sign_in_successful(user, loan_id)
    loan = Loan.find(loan_id)
    self.class.with(loan: loan, user: user)
  end
end
