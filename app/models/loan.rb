class Loan < ActiveRecord::Base
  include Confirmable
  include Publishable

  belongs_to :creator,  class_name: 'User'
  belongs_to :group,    class_name: 'LoanGroup'

  # has_many :through definitions must remain in this order until this issue is
  # resolved: https://github.com/rails/rails/issues/16139
  has_many :loan_borrowers
  has_many :borrowers,  class_name: 'User',
                        source:     :borrower,
                        through:    :loan_borrowers
  has_many :loan_lenders
  has_many :lenders,  class_name: 'User',
                      source:     :lender,
                      through:    :loan_lenders
  has_many :loan_participants
  has_many :participants, class_name: 'User',
                          source:     :user,
                          through:    :loan_participants

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :borrowers, presence: true
  validates :creator,   presence: true
  validates :lenders,   exclusion:  { in: :borrowers },
                        presence:   true

  monetize :amount_cents
end
