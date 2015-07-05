class PublicityStateMachine
  include Statesman::Machine

  ACTIONS = {
    # <method>:     :<state>
    cancel:     :canceled,
    delete:     :deleted,
    publish:    :published,
    unpublish:  :unpublished
  }

  state :unpublished, initial: true
  state :published
  state :canceled
  state :deleted

  transition from: :unpublished,  to: %i(canceled published)
  transition from: :published,    to: %i(deleted)
end
