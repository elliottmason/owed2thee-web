ActionMailer::DeliveryJob.rescue_from(StandardError) do |exception|
  Rollbar.error(exception)
end
