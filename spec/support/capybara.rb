require 'capybara/poltergeist'

Capybara.asset_host         = 'http://localhost:3000'
Capybara.javascript_driver  = :poltergeist

require 'capybara/rspec'
require 'capybara-screenshot/rspec'

Capybara::Screenshot.prune_strategy = :keep_last_run

require 'site_prism'
