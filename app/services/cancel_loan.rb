class CancelLoan < BaseService
  attr_reader :loan

  def initialize(loan)
    @loan = loan
  end

  def perform
    @successful = loan.cancel!
  end

  def successful?
    @successful
  end
end