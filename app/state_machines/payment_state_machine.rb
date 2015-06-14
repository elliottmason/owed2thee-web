class PaymentStateMachine
  include Statesman::Machine

  ACTIONS = {}

  state :unpaid, initial: true
  state :partially_paid
  state :fully_paid

  transition from: :unpaid, to: %i(fully_paid partially_paid)
  transition from: :partially_paid, to: %i(fully_paid)
end
