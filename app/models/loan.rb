class Loan < Transfer
  # has_many :through definitions must remain in this order until this issue is
  # resolved: https://github.com/rails/rails/issues/16139
  has_many :loan_borrowers, as: :participable
  has_many :borrowers, class_name: 'User', through: :loan_borrowers
  has_many :loan_lenders, as: :participable
  has_many :lenders, class_name: 'User', through: :loan_lenders
  has_many :loan_participants, as: :participable
  has_many :participants, through: :loan_participants

  validates :borrowers, presence: true
  validates :lenders,   exclusion:  { in: :borrowers }, presence:   true

  transitional :payment
end
