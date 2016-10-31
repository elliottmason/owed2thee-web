module ConfirmationStateMachine
  ACTIONS = {
    confirm: :confirmed
  }.freeze

  def self.included(base)
    base.class_eval do
      state :confirmed
      state :unconfirmed, initial: true

      transition from: :unconfirmed, to: :confirmed
    end
  end
end
