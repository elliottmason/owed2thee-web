class User < ActiveRecord::Base
  include Transitional
  include Uuidable
  include Wisper::Publisher

  has_many :user_contacts
  has_many :contacts, class_name: 'User', through: :user_contacts
  has_many :email_addresses
  has_many :debts, class_name: 'Loan', foreign_key: :recipient_id
  has_many :loans, foreign_key: :sender_id
  has_many :payments, foreign_key: :sender_id

  validates :email_addresses, presence: true

  devise :database_authenticatable
  devise :registerable
  devise :rememberable
  devise :trackable

  transitional :confirmation

  # A User can have multiple emails associated with his or her account, so we
  # retrieve a User through an EmailAddress record
  def self.find_for_database_authentication(conditions)
    email_address = EmailAddress.
                    in_confirmation_state(:confirmed).
                    find_by(address: conditions[:email])
    email_address.user if email_address
  end

  def no_password?
    !password?
  end

  def password?
    encrypted_password.present?
  end

  def primary_email_address
    email_addresses.first
  end
end
