class ConfirmationStateMachine
  include Statesman::Machine

  state :unconfirmed, initial: true
  state :disputed
  state :confirmed

  transition from: :unconfirmed,  to: %i(confirmed disputed)
  transition from: :disputed,     to: %i(confirmed)
  transition from: :confirmed,    to: %i(unconfirmed)
end
