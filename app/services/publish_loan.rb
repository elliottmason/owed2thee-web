class PublishLoan < BaseService
  include Wisper::Publisher

  def initialize(loan = nil)
    @loan = loan

    subscribe(NotifyLoanParticipants.new)
  end

  def create_loan_successful(loan)
    self.class.with(loan) if loan.participants.in_state(:confirmed).count >= 1
  end

  def confirm_loan_participation_successful(loan_participant)
    self.class.with(loan_participant.loan)
  end

  def perform
    @loan.publish!

    broadcast(:publish_loan_successful, @loan) if successful?
  end

  def successful?
    @loan.published?
  end
end
