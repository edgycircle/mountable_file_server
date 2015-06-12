$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'
require 'rack/test'

require 'mountable_file_server'

module PathHelper
  def path(filename)
    File.expand_path(File.join('fixtures', filename), File.dirname(__FILE__))
  end
end

class IntegrationTestCase < MiniTest::Test
  include Rack::Test::Methods
  include PathHelper
end
