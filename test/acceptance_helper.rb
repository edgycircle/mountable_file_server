$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../rails-dummy/config/environment.rb",  __FILE__)
require 'mountable_file_server'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.current_driver = :poltergeist
# ActionController::Base.allow_forgery_protection = true

module PathHelper
  def path(filename)
    File.expand_path(File.join("fixtures", filename), File.dirname(__FILE__))
  end
end

class AcceptanceTestCase < MiniTest::Test
  include Capybara::DSL
  include PathHelper
end
