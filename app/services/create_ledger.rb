class CreateLedger < BaseService
  def initialize(loan_participant = nil)
    @loan_participant = loan_participant
  end

  def borrower
    loan_participant.user
  end

  def confirm_loan_participation_successful(loan_participant)
    self.class.with(loan_participant)
  end

  def ledger
    @ledger ||= Ledger.between(borrower, lender).first_or_initiailze
  end

  delegate :lenders, to: :loan

  delegate :loan, to: :loan_participant

  attr_reader :loan_participant

  def perform
    @successful = ledger.save unless ledger.persisted?
  end

  def successful?
    @successful
  end
end
