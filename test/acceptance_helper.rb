$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../rails-dummy/config/environment.rb",  __FILE__)
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

  def setup
    FileUtils.mkdir_p Rails.configuration.mountable_file_server.stored_at
    FileUtils.mkdir_p File.join(Rails.configuration.mountable_file_server.stored_at, 'tmp')
    FileUtils.mkdir_p File.join(Rails.configuration.mountable_file_server.stored_at, 'public')
  end

  def teardown
    FileUtils.rm_rf Rails.configuration.mountable_file_server.stored_at
  end
end
