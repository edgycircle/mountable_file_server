require 'unit_helper'
require 'tempfile'
require 'pathname'

class FileAccessorTest < UnitTestCase
  Identifier = MountableFileServer::Identifier
  FileAccessor = MountableFileServer::FileAccessor
  Configuration = MountableFileServer::Configuration

  def test_temporary_pathname
    configuration = Configuration.new stored_at: '/some/path/'

    [
      { id: 'public-test.jpg', path: '/some/path/tmp/public-test.jpg' },
      { id: 'private-test.jpg', path: '/some/path/tmp/private-test.jpg' }
    ].each do |pair|
      file_acccessor = FileAccessor.new Identifier.new(pair[:id]), configuration
      assert_equal Pathname(pair[:path]), file_acccessor.temporary_pathname
    end
  end

  def test_permanent_pathname
    configuration = Configuration.new stored_at: '/some/path/'

    [
      { id: 'public-test.jpg', path: '/some/path/public/public-test.jpg' },
      { id: 'private-test.jpg', path: '/some/path/private/private-test.jpg' }
    ].each do |pair|
      file_acccessor = FileAccessor.new Identifier.new(pair[:id]), configuration
      assert_equal Pathname(pair[:path]), file_acccessor.permanent_pathname
    end
  end

  def test_finds_pathname_based_on_file_location
    [
      { id: 'public-test.jpg', location: 'public/public-test.jpg' },
      { id: 'public-test.jpg', location: 'tmp/public-test.jpg' },
      { id: 'private-test.jpg', location: 'private/private-test.jpg' },
      { id: 'private-test.jpg', location: 'tmp/private-test.jpg' }
    ].each do |pair|
      Dir.mktmpdir do |directory|
        stored_at = Pathname(directory)
        configuration = Configuration.new stored_at: stored_at
        file = stored_at + pair[:location]
        file.dirname.mkdir
        file.write 'test'

        file_acccessor = FileAccessor.new Identifier.new(pair[:id]), configuration
        assert_equal file, file_acccessor.pathname
      end
    end
  end

  def test_pathname_raises_error_when_no_file_is_present
    id = MountableFileServer::Identifier.new 'public-unknown.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id

    assert_raises(MountableFileServer::NoFileForIdentifier) { file_acccessor.pathname }
  end

  def test_exist_returns_false_when_no_file_is_present
    id = MountableFileServer::Identifier.new 'public-unknown.jpg'
    refute MountableFileServer::FileAccessor.new(id).exist?
  end

  def test_exist_checks_all_possible_file_locations
    [
      { id: 'public-test.jpg', location: 'public/public-test.jpg' },
      { id: 'public-test.jpg', location: 'tmp/public-test.jpg' },
      { id: 'private-test.jpg', location: 'private/private-test.jpg' },
      { id: 'private-test.jpg', location: 'tmp/private-test.jpg' }
    ].each do |pair|
      Dir.mktmpdir do |directory|
        stored_at = Pathname(directory)
        configuration = Configuration.new stored_at: stored_at
        file = stored_at + pair[:location]
        file.dirname.mkdir
        file.write 'test'

        file_acccessor = FileAccessor.new Identifier.new(pair[:id]), configuration
        assert file_acccessor.exist?
      end
    end
  end

  def test_public_id_has_an_url
    configuration = MountableFileServer::Configuration.new mounted_at: '/abc'
    id = MountableFileServer::Identifier.new 'public-test.png'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_equal '/abc/public-test.png', file_acccessor.url
  end

  def test_private_id_has_no_url
    id = MountableFileServer::Identifier.new 'private-test.png'
    file_acccessor = MountableFileServer::FileAccessor.new id

    assert_raises(MountableFileServer::NotAccessibleViaURL) do
      file_acccessor.url
    end
  end
end
