require 'unit_helper'

class AccessFilesystemTest < UnitTestCase
  def setup
    FileUtils.mkdir_p temporary_path
    FileUtils.mkdir_p public_path
    FileUtils.mkdir_p private_path
  end

  def teardown
    FileUtils.rm_rf temporary_path
    FileUtils.rm_rf public_path
    FileUtils.rm_rf private_path
  end

  def test_file_for_with_public_identifier_string_in_temporary_storage
    identifier = 'public-david.jpg'
    FileUtils.cp original, File.join(temporary_path, identifier)
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_public_identifier_string_in_permanent_storage
    identifier = 'public-david.jpg'
    FileUtils.cp original, File.join(public_path, 'david.jpg')
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_public_identifier_object_in_temporary_storage
    identifier = MountableFileServer::Identifier.new 'public-david.jpg'
    FileUtils.cp original, File.join(temporary_path, identifier)
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_public_identifier_object_in_permanent_storage
    identifier = MountableFileServer::Identifier.new 'public-david.jpg'
    FileUtils.cp original, File.join(public_path, 'david.jpg')
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_private_identifier_string_in_temporary_storage
    identifier = 'private-david.jpg'
    FileUtils.cp original, File.join(temporary_path, identifier)
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_private_identifier_string_in_permanent_storage
    identifier = 'private-david.jpg'
    FileUtils.cp original, File.join(private_path, 'david.jpg')
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_private_identifier_object_in_temporary_storage
    identifier = MountableFileServer::Identifier.new 'private-david.jpg'
    FileUtils.cp original, File.join(temporary_path, identifier)
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  def test_file_for_with_private_identifier_object_in_permanent_storage
    identifier = MountableFileServer::Identifier.new 'private-david.jpg'
    FileUtils.cp original, File.join(private_path, 'david.jpg')
    file = access.file_for identifier: identifier
    assert_equal File.new(fixture_path('david.jpg')).read, file.read
  end

  private
  def configuration
    MountableFileServer::Configuration.new mounted_at: '/uploads', stored_at: File.join(temporary_path, '../')
  end

  def access
    MountableFileServer::Access.new configuration
  end

  def original
    fixture_path('david.jpg')
  end

  def temporary_path
    File.expand_path('../../tmp/test-uploads/tmp', File.dirname(__FILE__))
  end

  def public_path
    File.expand_path('../../tmp/test-uploads/public', File.dirname(__FILE__))
  end

  def private_path
    File.expand_path('../../tmp/test-uploads/private', File.dirname(__FILE__))
  end
end
