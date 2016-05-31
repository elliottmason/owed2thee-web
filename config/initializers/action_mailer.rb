ActionMailer::DeliveryJob.rescue_from(StandardError) do |exception|
  Rollbar.log(exception)
end
