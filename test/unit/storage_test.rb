require 'unit_helper'

class StorageTest < UnitTestCase
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

  def test_store_temporary
    type = 'public'
    path = fixture_path('david.jpg')
    identifier = storage.store_temporary path: path, type: 'public', filename: 'david.jpg'

    assert File.exist?(File.join(tmp_path, identifier))
  end

  def test_store_permanently
    type = 'public'
    path = fixture_path('david.jpg')
    identifier = storage.store_permanently path: path, type: 'public', filename: 'david.jpg'

    assert File.exist?(File.join(public_path, identifier.filename))
  end

  def test_identifier_is_unique_within_temporary_directory
    type = 'public'
    path = fixture_path('david.jpg')
    random_tokens = ['a', 'a', 'b']
    stub(SecureRandom).hex { random_tokens.shift }

    identifier_one = storage.store_temporary path: path, type: 'public', filename: 'david.jpg'
    identifier_two = storage.store_temporary path: path, type: 'public', filename: 'david.jpg'

    assert_equal 'public-a.jpg', identifier_one
    assert_equal 'public-b.jpg', identifier_two
  end

  def test_permanent_storage
    path = fixture_path('david.jpg')

    public_identifier = storage.store_temporary path: path, type: 'public', filename: 'david.jpg'
    private_identifier = storage.store_temporary path: path, type: 'private', filename: 'david.jpg'

    storage.move_to_permanent_storage identifier: public_identifier
    storage.move_to_permanent_storage identifier: private_identifier

    refute File.exists? File.join(tmp_path, public_identifier)
    refute File.exists? File.join(tmp_path, private_identifier)
    refute File.exists? File.join(private_path, public_identifier)
    refute File.exists? File.join(private_path, private_identifier)
    refute File.exists? File.join(public_path, public_identifier)
    refute File.exists? File.join(public_path, private_identifier)
    refute File.exists? File.join(private_path, public_identifier.filename)
    assert File.exists? File.join(private_path, private_identifier.filename)
    assert File.exists? File.join(public_path, public_identifier.filename)
    refute File.exists? File.join(public_path, private_identifier.filename)
  end

  def test_removing_identifiers
    path = fixture_path('david.jpg')

    public_identifier = storage.store_temporary path: path, type: 'public', filename: 'david.jpg'
    private_identifier = storage.store_temporary path: path, type: 'private', filename: 'david.jpg'

    storage.move_to_permanent_storage identifier: public_identifier
    storage.move_to_permanent_storage identifier: private_identifier

    storage.remove_from_permanent_storage identifier: public_identifier
    storage.remove_from_permanent_storage identifier: private_identifier

    refute File.exists? File.join(private_path, private_identifier.filename)
    refute File.exists? File.join(public_path, public_identifier.filename)
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
      tempfile: File.new(fixture_path('david.jpg'))
    }
  end

  def configuration
    MountableFileServer::Configuration.new mounted_at: '/uploads', stored_at: File.join(tmp_path, '../')
  end

  def storage
    MountableFileServer::Storage.new configuration
  end
end
