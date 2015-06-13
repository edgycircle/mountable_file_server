require 'unit_helper'

class ConfigurationTest < UnitTestCase
  def test_options_can_be_read
    configuration = MountableFileServer::Configuration.new mounted_at: '/uploads', stored_at: './uploads'

    assert_equal '/uploads', configuration.mounted_at
    assert_equal './uploads', configuration.stored_at
  end
end
