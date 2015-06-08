class PublicityStateMachine
  include Statesman::Machine

  state :unpublished, initial: true
  state :published

  transition from: :unpublished,  to: %i(published)
  transition from: :published,    to: %i(unpublished)
end
