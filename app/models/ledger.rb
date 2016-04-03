class Ledger < ActiveRecord::Base
  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validates :user_a,  presence: true
  validates :user_b,  presence: true
  validates_with LedgerUniquenessValidator, on: :create

  monetize :confirmed_balance_cents
  monetize :projected_balance_cents

  alias _confirmed_balance confirmed_balance
  def confirmed_balance(user = nil)
    return _confirmed_balance if user.nil? || (user.present? && user == user_a)
    return -_confirmed_balance if user == user_b
  end

  def users
    [user_a, user_b]
  end

  alias _projected_balance projected_balance
  def projected_balance(user = nil)
    return _projected_balance if user.nil? || (user.present? && user == user_a)
    return -_projected_balance if user == user_b
  end
end
