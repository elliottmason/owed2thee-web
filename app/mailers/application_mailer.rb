class ApplicationMailer < ActionMailer::Base
  class << self
    def app_title
      I18n.t('app.title')
    end

    def domain_name
      Rails.application.secrets.domain_name
    end

    def rescue_from(error)
      Rollbar.log(error)
    end
  end

  include Rollbar::ActiveJob

  default from: "#{app_title} <notifications@#{domain_name}>"
  default host: domain_name

  private

  def app_title
    self.class.app_title
  end
end
