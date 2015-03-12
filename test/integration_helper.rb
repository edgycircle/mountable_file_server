$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'
require 'rack/test'

require 'mountable_file_server'

module PathHelper
  def path(filename)
    File.expand_path(File.join("fixtures", filename), File.dirname(__FILE__))
  end
end

class IntegrationTestCase < MiniTest::Test
  include Rack::Test::Methods
  include PathHelper

  def app
    MountableFileServer::Backend.new
  end

  def setup
    MountableFileServer.configure do |config|
      config.stored_at = File.expand_path('../../tmp/test-uploads/', __FILE__)
      config.root = ''
    end
  end
end
