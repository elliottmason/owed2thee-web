class EmailAddressConfirmationMailer < ApplicationMailer
  def email(user)
    @user       = user
    @presenter  = EmailAddressConfirmationMailerPresenter.new(email_address)
    mail(to: to, subject: subject)
  end

  private

  attr_reader :user

  def email_address
    @email_address ||= EmailAddressQuery.most_recent_unconfirmed_for_user(user)
  end

  def subject
    "[#{t('app.title')}] - Confirm your email address"
  end

  def to
    email_address.address
  end
end