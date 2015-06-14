class DisputeStateMachine < ConfirmationStateMachine
  include ConfirmableStateMachine

  ACTIONS = ACTIONS.merge(
    dispute: :disputed
  )

  state :disputed

  transition from: :unconfirmed,  to: %i(disputed)
  transition from: :disputed,     to: %i(confirmed)
  transition from: :confirmed,    to: %i(disputed)
end
