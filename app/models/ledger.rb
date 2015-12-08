class Ledger < ActiveRecord::Base
  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validates :user_a,  presence: true
  validates :user_b,  presence: true
  validates_with LedgerUniquenessValidator

  before_create :synchronize_balances

  monetize :confirmed_balance_cents
  monetize :projected_balance_cents

  def confirmed_balance_for(user)
    return -confirmed_balance if user == user_a
    return confirmed_balance  if user == user_b
  end

  def payable?(user)
    confirmed_balance_for(user) > 0
  end

  # TODO: calculate Payments
  def sum_confirmed_balance
    self[:confirmed_balance_cents] =
      user_a.loans.in_state(:confirmed).sum(:amount_cents) -
      user_b.loans.in_state(:confirmed).sum(:amount_cents)
  end

  # TODO: calculate Payments
  def sum_projected_balance
    self[:projected_balance_cents] =
      user_a.loans.in_state(:unconfirmed).sum(:amount_cents) -
      user_b.loans.in_state(:unconfirmed).sum(:amount_cents)
  end

  def synchronize_balances
    sum_confirmed_balance
    sum_projected_balance
  end
end
