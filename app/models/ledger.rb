class Ledger < ActiveRecord::Base
  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validates :user_a,  presence: true
  validates :user_b,  presence: true
  validates_with LedgerUniquenessValidator

  before_create :synchronize

  monetize :confirmed_balance_cents
  monetize :projected_balance_cents

  def self.between(user_a, user_b)
    where(user_a: [user_a, user_b], user_b: [user_a, user_b])
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

  def synchronize
    sum_confirmed_balance
    sum_projected_balance
  end

  def synchronize!
    synchronize
    save
  end
end
