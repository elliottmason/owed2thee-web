class ApplicationMailer < ActionMailer::Base
  default from: 'postmaster@' + Rails.application.secrets.domain_name

  private

  def app_title
    I18n.t('app.title')
  end
end
