class User < ActiveRecord::Base
  include Transitional
  include Uuidable
  include Wisper::Publisher

  has_many :email_addresses
  has_many :loan_borrowers, foreign_key: :user_id
  has_many :debts, class_name: 'Loan', source: :loan, through: :loan_borrowers
  has_many :loan_lenders
  has_many :loans, through: :loan_lenders

  validates :email_addresses, presence: true

  devise :database_authenticatable
  devise :recoverable
  devise :registerable
  devise :rememberable
  devise :trackable

  transitional :confirmation

  # A User can have multiple emails associated with his or her account, so we
  # retrieve a User through an EmailAddress record
  def self.find_for_database_authentication(conditions)
    email_address = EmailAddress \
                    .in_state(:confirmed) \
                    .where(address: conditions[:email]) \
                    .first
    email_address.user if email_address
  end

  def no_password?
    !password?
  end

  def password?
    encrypted_password.present?
  end

  def new?
    last_sign_in_at.blank?
  end

  def primary_email_address
    email_addresses.first.address
  end

  private

  # Devise voodoo
  def email_changed?
    false
  end
end
