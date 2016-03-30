module ConfirmationToken
  def self.included(base)
    base.class_eval do
      include Transitional

      before_validation(on: :create) { generate_confirmation_token }

      validates :confirmation_token, presence: true, on: :create
      validates :confirmation_token, uniqueness: true, on: :create

      transitional :redemption
    end
  end

  def generate_confirmation_token
    self[:confirmation_token] = SecureRandom.urlsafe_base64(32)
  end
end
