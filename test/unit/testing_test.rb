require 'unit_helper'
require 'mountable_file_server/testing'

class TestTesting < MiniTest::Test
  def setup
    MountableFileServer::Testing.enable!
  end

  def teardown
    MountableFileServer::Testing.disable!
  end

  def test_testing_is_enabled_by_default
    assert MountableFileServer::Testing.enabled?
  end

  def test_normal_mode_is_used_by_default
    assert MountableFileServer::Testing.normal?
  end

  def test_testing_can_be_disabled
    MountableFileServer::Testing.disable!
    assert MountableFileServer::Testing.disabled?
  end

  def test_fake_mode_can_be_enabled
    MountableFileServer::Testing.fake!
    assert MountableFileServer::Testing.fake?
  end

  def test_remove_uploads_clears_storage_location
    fake_class(FileUtils)

    MountableFileServer::Testing.remove_uploads!
    assert_received FileUtils, :rm_rf, MountableFileServer.configuration.stored_at
  end
end
