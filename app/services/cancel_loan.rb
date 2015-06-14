class CancelLoan < BaseService
  include Wisper::Publisher

  attr_reader :loan

  def initialize(loan)
    @loan = loan

    subscribe(UnpublishLoan.new)
  end

  def perform
    @successful = loan.cancel!

    broadcast(:cancel_loan_successful, loan) if successful?
  end
end
