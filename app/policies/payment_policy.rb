class PaymentPolicy
  def initialize(user, payment)
    @payment  = payment
    @user     = user
  end

  def confirm?
    payment_is_unconfirmed? && user_is_participant? &&
      participant.confirmation.can_transition_to?(:confirmed)
  end

  def show?
    true
    # case payable
    # when Loan
    #   user_is_participant?
    # end
  end

  private

  def participant
    @participant ||= TransferParticipant.where(transfer:  payment,
                                               user_id:   user.id).first
  end

  attr_reader :payment

  def payment_is_unconfirmed?
    payment.unconfirmed?
  end

  attr_reader :user

  def user_is_participant?
    participant
  end
end
