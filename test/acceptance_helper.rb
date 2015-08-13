$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../rails-dummy/config/environment.rb",  __FILE__)
require 'capybara/rails'
require 'capybara/poltergeist'
require 'support/path_helper'

Capybara.current_driver = :poltergeist

class AcceptanceTestCase < MiniTest::Test
  include Capybara::DSL
  include PathHelper

  def setup
    FileUtils.mkdir_p MountableFileServer.configuration.stored_at
    FileUtils.mkdir_p File.join(MountableFileServer.configuration.stored_at, 'tmp')
    FileUtils.mkdir_p File.join(MountableFileServer.configuration.stored_at, 'public')
  end

  def teardown
    FileUtils.rm_rf MountableFileServer.configuration.stored_at
  end
end
