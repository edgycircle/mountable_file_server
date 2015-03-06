$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'

ENV['RAILS_ENV'] ||= 'test'
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
require File.expand_path("../rails-dummy/config/environment.rb",  __FILE__)
require 'mountable_file_server'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.current_driver = :poltergeist

module PathHelper
  def path(filename)
    File.expand_path(File.join("fixtures", filename), File.dirname(__FILE__))
  end
end

class AcceptanceTestCase < MiniTest::Test
  include Capybara::DSL
  include PathHelper
end
