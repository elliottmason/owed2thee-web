class ConfirmLoanParticipation < ConfirmTransferParticipation
  include Wisper::Publisher

  def initialize(*args)
    super
    subscribe(LoanParticipationListener.new)
  end

  alias_method :loan, :transfer

  private

  def broadcast_to_listeners
    broadcast(:confirm_loan_participation_successful, user, loan)
  end
end
