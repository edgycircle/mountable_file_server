$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'
require 'rack/test'
require 'support/path_helper'
require 'mountable_file_server'
require 'mountable_file_server/server'

class IntegrationTestCase < MiniTest::Test
  include Rack::Test::Methods
  include PathHelper

  def app
    @app = MountableFileServer::Server.new
  end
end
