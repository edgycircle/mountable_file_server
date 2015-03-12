require 'unit_helper'

class TestStorageHelper < MiniTest::Test
  def test_remove_files_throws_exception_outside_of_testing
    assert_raises SecurityError do
      MountableFileServer.remove_files!
    end
  end

  def test_remove_files_clears_storage_location
    fake_class(FileUtils)
    MountableFileServer.testing!
    MountableFileServer.remove_files!
    MountableFileServer.default!

    assert_received FileUtils, :rm_rf, MountableFileServer.configuration.stored_at
  end
end
