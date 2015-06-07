class User < ActiveRecord::Base
  include Confirmable

  has_many :emails, class_name: 'UserEmail'
  has_many :loan_borrowers, foreign_key: :borrower_id
  has_many :debts, class_name: 'Loan', source: :loan, through: :loan_borrowers
  has_many :loans, foreign_key: :lender_id

  devise :database_authenticatable
  devise :recoverable
  devise :registerable
  devise :rememberable
  devise :trackable
  devise :validatable
end
