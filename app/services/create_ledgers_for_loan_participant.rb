class CreateLedgersForLoanParticipant < BaseService
  def initialize(user = nil, loan = nil)
    @loan = loan
    @user = user
  end

  def confirm_loan_participation_successful(user, loan)
    self.class.with(user, loan)
  end

  def confirmed_borrowers
    @confirmed_borrowers = loan.loan_borrowers.includes(:user).map(&:user)
  end

  def confirmed_lenders
    @confirmed_lenders = loan.loan_lenders.includes(:user).map(&:user)
  end

  attr_reader :ledgers

  attr_reader :loan

  attr_reader :user

  def perform
    ActiveRecord::Base.transaction do
      @ledgers = confirmed_lenders.inject([]) do |ledgers, lender|
        confirmed_borrowers.each do |borrower|
          ledgers << FindOrCreateLedger.between(lender, borrower).ledger
        end
      end
    end
  end
end
