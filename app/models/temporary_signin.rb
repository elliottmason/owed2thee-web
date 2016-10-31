# Contains a unique confirmation token that is associated with a User. When
# redeemed, the user is signed in for the session.
class TemporarySignin < ActiveRecord::Base
  include ConfirmationToken

  belongs_to :email_address
  belongs_to :user

  validates :email_address, presence: true
  validates :expires_at,    presence: true
  validates :user,          presence: true

  before_validation :set_expires_at, on: :create

  state_machine :TemporarySigninStateMachine

  def self.initial_state
    :unredeemed
  end

  def to_param
    confirmation_token
  end

  private

  def set_expires_at
    self[:expires_at] ||= Time.now.utc + 1.hour
  end
end
