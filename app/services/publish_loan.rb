class PublishLoan < BaseService
  include Wisper::Publisher

  def initialize(loan = nil)
    @loan = loan

    subscribe(LoanListener.new)
  end

  def perform
    @successful = @loan.publish!

    broadcast(:publish_loan_successful, @loan) if successful?
  end
end
