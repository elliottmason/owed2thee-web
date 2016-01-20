class TemporarySigninQuery < ApplicationQuery
  def initialize(relation = TemporarySignin.all)
    super
  end

  def self.confirmation_token(confirmation_token)
    new
      .relation
      .unexpired
      .unredeemed
      .confirmation_token(confirmation_token)
      .first
  end

  def self.recent_email_address(email_address)
    new
      .relation
      .unexpired
      .unredeemed
      .email_address(email_address)
      .first
  end

  def self.user(user)
    new
      .relation
      .unexpired
      .unredeemed
      .user(user)
  end

  module Scopes
    def confirmation_token(confirmation_token)
      where(confirmation_token: confirmation_token)
    end

    def email_address(email_address)
      where(email_address: email_address)
    end

    def unexpired
      where('expires_at >= ?', Time.now.utc)
    end

    def unredeemed
      in_state(:unredeemed)
    end

    def user(user)
      where(user: user)
    end
  end
end
