ActionMailer::DeliveryJob.rescue_from(StandardError) do |exception|
  Rollbar.error(exception)
  raise exception
end
