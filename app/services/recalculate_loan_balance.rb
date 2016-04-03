class RecalculateLoanBalance < ApplicationService
  attr_reader :loan

  def initialize(loan)
    @loan = loan
  end

  def perform
    recalculate_loan_balance
    @successful = loan.previous_changes[:balance_cents].present?
  end

  private

  def loan_balance
    loan.balance_cents - loan.loan_payments.sum(:amount_cents)
  end

  def recalculate_loan_balance
    raise ActiveRecord::Rollback unless
      @loan.update_attributes(balance_cents: loan_balance)
  end
end
