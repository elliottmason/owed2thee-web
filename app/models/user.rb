class User < ActiveRecord::Base
  include Confirmable

  attr_accessor :email

  has_many :emails, class_name: 'UserEmail'
  has_many :loan_borrowers, foreign_key: :user_id
  has_many :debts, class_name: 'Loan', source: :loan, through: :loan_borrowers
  has_many :loan_lenders
  has_many :loans, through: :loan_lenders

  validates :emails, presence: true

  devise :database_authenticatable
  devise :registerable
  devise :rememberable
  devise :trackable

  # A User can have multiple emails associated with his or her account, so we
  # retrieve a User through a UserEmail record
  def self.find_for_database_authentication(conditions)
    if (user_email = UserEmail.confirmed.where(email: conditions[:email]).first)
      if (user = user_email.user)
        user.email = user_email.email
        return user
      end
    end
  end
end
