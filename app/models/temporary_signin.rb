# Contains a unique confirmation token that is associated with a User. When
# redeemed, the user is signed in for the session.
class TemporarySignin < ActiveRecord::Base
  include Transitional
  include ConfirmationToken

  belongs_to :email_address
  belongs_to :user

  validates :email_address, presence: true
  validates :expires_at,    presence: true
  validates :user,          presence: true

  before_validation :set_expires_at, on: :create

  transitional :redemption

  private

  def set_expires_at
    self[:expires_at] ||= Time.now.utc + 1.hour
  end
end
