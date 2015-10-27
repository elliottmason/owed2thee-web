class ConfirmLoanParticipation < ConfirmTransferParticipation
  include Wisper::Publisher

  def initialize(*args)
    super

    subscribe(LoanParticipationListener.new)
  end

  alias_method :loan, :participable

  def perform
    super

    broadcast(:confirm_loan_participation_successful, user, loan) \
      if successful?
  end
end
