class PublishLoan < BaseService
  def initialize(loan = nil)
    @loan = loan
  end

  def create_loan_successful(loan)
    self.class.with(loan) if loan.participants.in_state(:confirmed).count >= 1
  end

  def confirm_loan_participant_successful(loan_participant)
    self.class.with(loan_participant.loan)
  end

  def perform
    @loan.publicity.transition_to!(:published)
  end
end
