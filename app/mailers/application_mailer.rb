class ApplicationMailer < ActionMailer::Base
  class << self
    def app_title
      I18n.t('app.title')
    end

    def domain_name
      Rails.application.secrets.domain_name
    end
  end

  default from: "#{app_title} <notifications@#{domain_name}>"

  private

  def app_title
    self.class.app_title
  end
end
