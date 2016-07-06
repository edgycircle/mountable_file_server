require 'unit_helper'
require 'stringio'
require 'tempfile'

require 'mountable_file_server/storage'
require 'mountable_file_server/unique_identifier'
require 'mountable_file_server/file_accessor'

class StorageTest < UnitTestCase
  attr_reader :uid, :file_accessor, :storage

  Storage = MountableFileServer::Storage
  UniqueIdentifier = MountableFileServer::UniqueIdentifier
  FileAccessor = MountableFileServer::FileAccessor

  def setup
    MountableFileServer.configure do |config|
      config.base_url = 'http://test.test/uploads/'
      config.storage_path = Dir.mktmpdir
    end

    @uid = UniqueIdentifier.new 'public-test.txt'
    @file_accessor = FileAccessor.new uid
    @storage = Storage.new
  end

  def teardown
    Pathname(MountableFileServer.config.storage_path).rmtree
  end

  def test_store_io_input_temporary
    storage.store_temporary uid, StringIO.new('test')
    assert_equal 'test', file_accessor.temporary_pathname.read
  end

  def test_store_io_input_permanent
    storage.store_permanent uid, StringIO.new('test')
    assert_equal 'test', file_accessor.permanent_pathname.read
  end

  def test_store_pathname_input_temporary
    Tempfile.open('input') do |file|
      file.write 'test'
      file.rewind

      storage.store_temporary uid, file.path
      assert_equal 'test', file_accessor.temporary_pathname.read
    end
  end

  def test_store_pathname_input_permanent
    Tempfile.open('input') do |file|
      file.write 'test'
      file.rewind

      storage.store_permanent uid, file.path
      assert_equal 'test', file_accessor.permanent_pathname.read
    end
  end

  def test_move_to_permanent_storage
    temporary_pathname = file_accessor.temporary_pathname
    temporary_pathname.dirname.mkpath

    File.open(temporary_pathname, 'w') { |f| f.write 'test' }

    storage.move_to_permanent_storage uid

    refute file_accessor.temporary_pathname.file?
    assert file_accessor.permanent_pathname.file?
    assert_equal 'test', file_accessor.permanent_pathname.read
  end

  def test_remove_from_permanent_storage
    pathname = file_accessor.permanent_pathname
    pathname.dirname.mkpath

    File.open(pathname, 'w') { |f| f.write 'test' }

    storage.remove_from_storage uid

    refute file_accessor.permanent_pathname.file?
  end

  def test_remove_from_temporary_storage
    pathname = file_accessor.temporary_pathname
    pathname.dirname.mkpath

    File.open(pathname, 'w') { |f| f.write 'test' }

    storage.remove_from_storage uid

    refute file_accessor.temporary_pathname.file?
  end
end
