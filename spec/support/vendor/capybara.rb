require "capybara/rspec"

Capybara.default_wait_time = 10

RSpec.configure do |config|
  config.include Capybara::DSL, type: :feature

  config.after type: :feature do
    page.driver.reset!
    Capybara.reset_sessions!
  end
end
