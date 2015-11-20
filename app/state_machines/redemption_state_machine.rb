class RedemptionStateMachine
  include Statesman::Machine

  ACTIONS = {
    cancel: :canceled,
    redeem: :redeemed
  }

  state :canceled
  state :redeemed
  state :unredeemed, initial: true

  transition from: :unredeemed, to: %i(canceled redeemed)
end
