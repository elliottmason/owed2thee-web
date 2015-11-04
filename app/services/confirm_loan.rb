class ConfirmLoan < BaseService
  include Wisper::Publisher

  attr_reader :force
  attr_reader :loan

  def initialize(loan, force = false)
    @force  = force
    @loan   = loan

    subscribe(LoanListener.new)
  end

  def confirmed_by_all_participants?
    loan.participants.in_state(:confirmed).count == loan.participants.count
  end

  alias_method :force?, :force

  def perform
    return unless confirmed_by_all_participants? || force?

    @successful = @loan.confirm!

    broadcast_to_listeners if successful?
  end

  private

  def broadcast_to_listeners
    broadcast(:confirm_loan_successful, loan)
  end
end
