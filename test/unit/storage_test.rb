require 'unit_helper'

class StorageTest < MiniTest::Test
  def setup
    FileUtils.mkdir_p tmp_path
    FileUtils.mkdir_p public_path
    FileUtils.mkdir_p private_path
  end

  def teardown
    FileUtils.rm_rf tmp_path
    FileUtils.rm_rf public_path
    FileUtils.rm_rf private_path
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

  def test_permanent_storage
    storage = MountableFileServer::Storage.new configuration
    public_upload = MountableFileServer::Upload.new file: fake_upload_parameters, type: 'public'
    private_upload = MountableFileServer::Upload.new file: fake_upload_parameters, type: 'private'

    public_identifier = storage.store_temporary upload: public_upload
    private_identifier = storage.store_temporary upload: private_upload

    storage.move_to_permanent_storage identifier: public_identifier
    storage.move_to_permanent_storage identifier: private_identifier

    refute File.exists? File.join(tmp_path, public_identifier)
    refute File.exists? File.join(tmp_path, private_identifier)
    refute File.exists? File.join(private_path, public_identifier)
    refute File.exists? File.join(private_path, private_identifier)
    refute File.exists? File.join(public_path, public_identifier)
    refute File.exists? File.join(public_path, private_identifier)

    public_filename = public_identifier.gsub('public-', '')
    private_filename = private_identifier.gsub('private-', '')

    refute File.exists? File.join(private_path, public_filename)
    assert File.exists? File.join(private_path, private_filename)
    assert File.exists? File.join(public_path, public_filename)
    refute File.exists? File.join(public_path, private_filename)
  end

private
  def tmp_path
    File.expand_path('../../tmp/test-uploads/tmp', File.dirname(__FILE__))
  end

  def public_path
    File.expand_path('../../tmp/test-uploads/public', File.dirname(__FILE__))
  end

  def private_path
    File.expand_path('../../tmp/test-uploads/private', File.dirname(__FILE__))
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
