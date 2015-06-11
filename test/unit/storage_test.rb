require 'unit_helper'

class StorageTest < MiniTest::Test
  def setup
    FileUtils.mkdir_p tmp_path
  end

  def teardown
    FileUtils.rm_rf tmp_path
  end

  def test_temporary_storage
    upload = MountableFileServer::Upload.new file: fake_upload_parameters, type: 'public'
    storage = MountableFileServer::Storage.new configuration

    identifier = storage.store_temporary upload: upload

    assert File.exists? File.join(tmp_path, identifier)
  end

  def test_identifier_is_prefixed_with_type
    upload = MountableFileServer::Upload.new file: fake_upload_parameters, type: 'public'
    storage = MountableFileServer::Storage.new configuration

    identifier = storage.store_temporary upload: upload

    assert_match /public-\w+\.jpg/, identifier
  end

  def test_identifier_is_unique_within_temporary_directory
    random_tokens = ['a', 'a', 'b']
    stub(SecureRandom).hex { random_tokens.shift }

    upload = MountableFileServer::Upload.new file: fake_upload_parameters, type: 'public'
    storage = MountableFileServer::Storage.new configuration

    identifier_one = storage.store_temporary upload: upload
    identifier_two = storage.store_temporary upload: upload

    assert_equal 'public-a.jpg', identifier_one
    assert_equal 'public-b.jpg', identifier_two
  end

private
  def tmp_path
    File.expand_path('../../tmp/test-uploads/tmp', File.dirname(__FILE__))
  end

  def fake_upload_parameters
    {
      filename: 'david.jpg',
      tempfile: File.new(File.expand_path(File.join('../fixtures', 'david.jpg'), File.dirname(__FILE__)))
    }
  end

  def configuration
    MountableFileServer::Configuration.new mounted_at: '', stored_at: File.join(tmp_path, '../')
  end
end
