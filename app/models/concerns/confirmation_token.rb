module ConfirmationToken
  def self.included(base)
    base.class_eval do
      before_validation(on: :create) { generate_confirmation_token }

      validates_presence_of   :confirmation_token, on: :create
      validates_uniqueness_of :confirmation_token, on: :create
    end
  end

  def generate_confirmation_token
    self[:confirmation_token] = SecureRandom.base64(32)
  end

  def confirm!
    self[:confirmation_token] = nil
    super if defined?(super)
  end
end
