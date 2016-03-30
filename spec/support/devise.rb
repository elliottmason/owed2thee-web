RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view

  config.before :each do
    Warden.test_mode!
  end
end
