class Ledger < ActiveRecord::Base
  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validates :user_a,  presence: true
  validates :user_b,  presence: true
  validates_with LedgerUniquenessValidator, on: :create

  before_create :update_balances

  monetize :confirmed_balance_cents
  monetize :projected_balance_cents

  def confirmed_balance_for(user)
    return confirmed_balance  if user == user_a
    return -confirmed_balance if user == user_b
  end

  def payable?(user)
    confirmed_balance_for(user) > 0
  end

  def projected_balance_for(user)
    return projected_balance  if user == user_a
    return -projected_balance if user == user_b
  end

  def sum_confirmed_balance
    self.confirmed_balance = Money.new(
      TransferQuery.confirmed.received(user_a, user_b).sum(:amount_cents) -
      TransferQuery.confirmed.sent(user_a, user_b).sum(:amount_cents)
    )
  end

  def sum_projected_balance
    self.projected_balance = Money.new(
      TransferQuery.published.received(user_a, user_b).sum(:amount_cents) -
      TransferQuery.published.sent(user_a, user_b).sum(:amount_cents)
    )
  end

  def update_balances
    sum_confirmed_balance
    sum_projected_balance
  end

  def update_balances!
    update_balances
    save!
  end
end
