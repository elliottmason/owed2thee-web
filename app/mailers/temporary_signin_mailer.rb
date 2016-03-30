class TemporarySigninMailer < ApplicationMailer
  delegate :confirmation_token, to: :temporary_signin

  def signin_link
    url_for([:user, :session, confirmation_token: confirmation_token])
  end

  def email(temporary_signin)
    @temporary_signin = temporary_signin
    @signin_link      = signin_link
    mail(to: to, subject: subject)
  end

  private

  attr_reader :temporary_signin

  def subject
  end

  def to
    user.primary_email_address.address
  end

  def user
    temporary_signin.user
  end
end
