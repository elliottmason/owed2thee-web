class TransferStateMachine < ApplicationStateMachine
  ACTIONS = {
    cancel:     :canceled,
    confirm:    :confirmed,
    dispute:    :disputed,
    publish:    :published,
    unpublish:  :unpublished
  }.freeze

  state :canceled
  state :confirmed
  state :disputed
  state :published
  state :unpublished, initial: true

  transition from: :confirmed,    to: %i(disputed)
  transition from: :disputed,     to: %i(canceled confirmed)
  transition from: :published,    to: %i(confirmed disputed)
  transition from: :unpublished,  to: %i(canceled published)
end
