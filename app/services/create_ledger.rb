class CreateLedgersFromLoan < BaseService
  def initialize(loan_participant = nil)
    @loan_participant = loan_participant
  end

  def borrower
    loan_participant.user
  end

  def confirmed_participants
    loan.loan_participants.in_state(:confirmed)
  end

  def confirm_loan_participation_successful(loan_participant)
    self.class.with(loan_participant)
  end

  def ledger
    @ledger ||= Ledger.between(borrower, lender).first_or_initiailze
  end

  def lender
    loan_participant.user
  end

  delegate :loan, to: :loan_participant

  attr_reader :loan_participant

  def perform
    @successful = ledger.save unless ledger.persisted?
  end
end
