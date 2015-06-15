class PaymentPolicy
  def initialize(user, payment)
    @payment  = payment
    @user     = user
  end

  def create?
    payment_published? && user_payee?
  end

  alias_method :new?, :create?

  def show?
    case payment.payable
    when Loan
      user_is_participant?
    end
  end

  private

  def loan_lender
    loan.loan_lenders.where(user: user).first
  end

  def loan_participant
    @loan_participant ||= LoanParticipant.where(loan: payable,
                                                user: user).first
  end

  def payable
    payment.payable
  end

  attr_reader :payment

  def payment_published?
    loan.published?
  end

  attr_reader :user

  def user_is_participant?
    loan_participant
  end
end
