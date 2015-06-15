class PublishLoan < BaseService
  include Wisper::Publisher

  def initialize(loan = nil)
    @loan = loan

    subscribe(NotifyLoanParticipants.new)
  end

  def confirm_loan_participation_successful(_, loan)
    self.class.with(loan)
  end

  def perform
    @successful = @loan.publish!

    broadcast(:publish_loan_successful, @loan) if successful?
  end
end
