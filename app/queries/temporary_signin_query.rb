class TemporarySigninQuery < BaseQuery
  def initialize(relation = TemporarySignin.all)
    super.unredeemed
  end

  def self.confirmation_token(confirmation_token)
    new
      .relation
      .confirmation_token(confirmation_token)
      .first
  end

  def self.recent_email_address(email_address)
    new
      .relation
      .email_address(email_address)
      .first
  end

  def self.user(user)
    new
      .relation
      .user(user)
  end

  module Scopes
    def confirmation_token(confirmation_token)
      where(confirmation_token: confirmation_token)
    end

    def email_address(email_address)
      where(email_address: email_address)
    end

    def unredeemed
      in_state(:unredeemed)
    end

    def user(user)
      where(user: user)
    end
  end
end
