class TemporarySigninMailer < ApplicationMailer
  delegate :confirmation_token, to: :temporary_signin

  def email(temporary_signin)
    @temporary_signin = temporary_signin
    @url              = url
    mail(to: to, subject: subject)
  end

  private

  attr_reader :temporary_signin

  delegate :email_address, :user, to: :temporary_signin

  def to
    email_address.address
  end
end
