class Loan < ActiveRecord::Base
  include Confirmable

  belongs_to :creator,  class_name: 'User'
  belongs_to :group,    class_name: 'LoanGroup'
  belongs_to :lender,   class_name: 'User'

  # these definitions must remain in this order until this issue is resolved:
  # https://github.com/rails/rails/issues/16139
  has_many :loan_borrowers
  has_many :borrowers,  class_name: 'User',
                        source:     :borrower,
                        through:    :loan_borrowers

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :borrowers, presence: true
  validates :creator,   presence: true
  validates :lender,    exclusion:  { in: :borrowers },
                        presence:   true

  monetize :amount_cents
end
