require 'unit_helper'
require 'stringio'
require 'tempfile'

class StorageTest < UnitTestCase
  attr_reader :configuration, :uid, :file_accessor, :storage

  Storage = MountableFileServer::Storage
  UniqueIdentifier = MountableFileServer::UniqueIdentifier
  FileAccessor = MountableFileServer::FileAccessor
  Configuration = MountableFileServer::Configuration

  def setup
    @configuration = Configuration.new stored_at: Dir.mktmpdir
    @uid = UniqueIdentifier.new 'public-test.txt'
    @file_accessor = FileAccessor.new uid, configuration
    @storage = Storage.new configuration
  end

  def teardown
    Pathname(configuration.stored_at).rmtree
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
    temporary_pathname.write 'test'

    storage.move_to_permanent_storage uid

    refute file_accessor.temporary_pathname.file?
    assert file_accessor.permanent_pathname.file?
    assert_equal 'test', file_accessor.permanent_pathname.read
  end

  def test_remove_from_permanent_storage
    permanent_pathname = file_accessor.permanent_pathname
    permanent_pathname.dirname.mkpath
    permanent_pathname.write 'test'

    storage.remove_from_permanent_storage uid

    refute file_accessor.permanent_pathname.file?
  end
end
