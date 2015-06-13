$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/hell'
require 'bogus/minitest'
require 'support/path_helper'
require 'mountable_file_server'

class UnitTestCase < MiniTest::Test
  include PathHelper
end
