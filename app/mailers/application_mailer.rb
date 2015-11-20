class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@owed2thee.com'

  private

  def app_title
    I18n.t('app.title')
  end
end
