class PaymentStateMachine
  include Statesman::Machine

  ACTIONS = {
    absolve: :absolved
  }.freeze

  state :unpaid, initial: true
  state :partially_paid
  state :fully_paid
  state :absolved

  transition from: :unpaid, to: %i(fully_paid partially_paid absolved)
  transition from: :partially_paid, to: %i(fully_paid absolved)
end
