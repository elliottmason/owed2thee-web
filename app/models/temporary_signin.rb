class TemporarySignin < ActiveRecord::Base
  include Transitional
  include ConfirmationToken

  belongs_to :email_address
  belongs_to :user
  # has_many :temporary_signin_transfers
  # has_many :unfinished_transfers, through: :temporary_signin_transfers

  validates :expires_at, presence: true
  validates :user, presence: true

  before_validation :set_expires_at, on: :create

  transitional :redemption

  private

  def set_expires_at
    self[:expires_at] ||= Time.now.utc + 1.hour
  end
end
