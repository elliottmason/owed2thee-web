module ConfirmableStateMachine
  ACTIONS = {
    confirm:    :confirmed,
    unconfirm:  :unconfirm
  }

  def self.included(base)
    base.class_eval do
      include Statesman::Machine

      state :unconfirmed, initial: true
      state :confirmed

      transition from: :unconfirmed, to: %i(confirmed)
    end
  end
end
