require 'unit_helper'
require 'tempfile'
require 'pathname'

require 'mountable_file_server/uri'

class FileAccessorTest < UnitTestCase
  UniqueIdentifier = MountableFileServer::UniqueIdentifier
  FileAccessor = MountableFileServer::FileAccessor
  URI = MountableFileServer::URI

  def test_temporary_pathname
    skip 'Adapt for new code'
    configuration = Configuration.new '', '/some/path/'

    [
      { uid: 'public-test.jpg', path: '/some/path/tmp/public-test.jpg' },
      { uid: 'private-test.jpg', path: '/some/path/tmp/private-test.jpg' }
    ].each do |pair|
      file_acccessor = FileAccessor.new UniqueIdentifier.new(pair[:uid]), configuration
      assert_equal Pathname(pair[:path]), file_acccessor.temporary_pathname
    end
  end

  def test_permanent_pathname
    skip 'Adapt for new code'
    configuration = Configuration.new '', '/some/path/'

    [
      { uid: 'public-test.jpg', path: '/some/path/public/public-test.jpg' },
      { uid: 'private-test.jpg', path: '/some/path/private/private-test.jpg' }
    ].each do |pair|
      file_acccessor = FileAccessor.new UniqueIdentifier.new(pair[:uid]), configuration
      assert_equal Pathname(pair[:path]), file_acccessor.permanent_pathname
    end
  end

  def test_finds_pathname_based_on_file_location
    skip 'Adapt for new code'
    [
      { uid: 'public-test.jpg', location: 'public/public-test.jpg' },
      { uid: 'public-test.jpg', location: 'tmp/public-test.jpg' },
      { uid: 'private-test.jpg', location: 'private/private-test.jpg' },
      { uid: 'private-test.jpg', location: 'tmp/private-test.jpg' }
    ].each do |pair|
      Dir.mktmpdir do |directory|
        stored_at = Pathname(directory)
        configuration = Configuration.new '', stored_at
        pathname = stored_at + pair[:location]
        pathname.dirname.mkdir

        File.open(pathname, 'w') { |f| f.write 'test' }

        file_acccessor = FileAccessor.new UniqueIdentifier.new(pair[:uid]), configuration
        assert_equal pathname, file_acccessor.pathname
      end
    end
  end

  def test_pathname_raises_error_when_no_file_is_present
    skip 'Adapt for new code'
    uid = UniqueIdentifier.new 'public-unknown.jpg'
    file_acccessor = FileAccessor.new uid

    assert_raises(MountableFileServer::MissingFile) { file_acccessor.pathname }
  end

  def test_exist_returns_false_when_no_file_is_present
    skip 'Adapt for new code'
    uid = UniqueIdentifier.new 'public-unknown.jpg'
    refute FileAccessor.new(uid).exist?
  end

  def test_exist_checks_all_possible_file_locations
    skip 'Adapt for new code'
    [
      { uid: 'public-test.jpg', location: 'public/public-test.jpg' },
      { uid: 'public-test.jpg', location: 'tmp/public-test.jpg' },
      { uid: 'private-test.jpg', location: 'private/private-test.jpg' },
      { uid: 'private-test.jpg', location: 'tmp/private-test.jpg' }
    ].each do |pair|
      Dir.mktmpdir do |directory|
        stored_at = Pathname(directory)
        configuration = Configuration.new '', stored_at
        pathname = stored_at + pair[:location]
        pathname.dirname.mkdir

        File.open(pathname, 'w') { |f| f.write 'test' }

        file_acccessor = FileAccessor.new UniqueIdentifier.new(pair[:uid]), configuration
        assert file_acccessor.exist?
      end
    end
  end

  def test_public_uid_has_an_url
    skip 'Adapt for new code'
    configuration = Configuration.new '/abc'
    uid = UniqueIdentifier.new 'public-test.png'
    file_acccessor = FileAccessor.new uid, configuration

    assert_equal '/abc/public-test.png', file_acccessor.url
    assert_instance_of URI, file_acccessor.url
  end

  def test_private_uid_has_no_url
    skip 'Adapt for new code'
    uid = UniqueIdentifier.new 'private-test.png'
    file_acccessor = FileAccessor.new uid

    assert_raises(MountableFileServer::NotAccessibleViaURL) do
      file_acccessor.url
    end
  end
end
