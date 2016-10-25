class PublicityStateMachine
  include Statesman::Machine

  ACTIONS = {
    # <method>:     :<state>
    cancel:     :canceled,
    publish:    :published,
    unpublish:  :unpublished
  }.freeze

  state :unpublished, initial: true
  state :published
  state :canceled

  transition from: :unpublished,  to: %i(canceled published)
  transition from: :published,    to: %i(canceled)
  transition from: :canceled,     to: %i(published unpublished)
end
