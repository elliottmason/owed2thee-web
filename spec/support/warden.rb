RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.before :each, :js do
    Warden.test_mode!
  end
end
