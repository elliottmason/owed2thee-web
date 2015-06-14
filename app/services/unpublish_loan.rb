class UnpublishLoan < BaseService
  attr_reader :loan

  def initialize(loan = nil)
    @loan = loan
  end

  def cancel_loan_successful(loan)
    self.class.with(loan)
  end

  def perform
    @successful = loan.unpublish!
  end
end
