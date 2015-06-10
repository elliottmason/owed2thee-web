class PublicityStateMachine
  include Statesman::Machine

  state :unpublished, initial: true
  state :published
  state :canceled

  transition from: :unpublished,  to: %i(canceled published)
  transition from: :published,    to: %i(canceled unpublished)
end
