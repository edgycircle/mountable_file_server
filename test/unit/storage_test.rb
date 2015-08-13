require 'unit_helper'
require 'stringio'
require 'tempfile'

class StorageTest < UnitTestCase
  def test_store_temporary
    stream = StringIO.new 'test'
    id = MountableFileServer::Identifier.new 'public-test.txt'
    pathname = MountableFileServer::FileAccessor.new(id).temporary_pathname

    persistor = MiniTest::Mock.new
    persistor.expect :new, persistor, [pathname]
    persistor.expect :save, nil, [stream]

    storage = MountableFileServer::Storage.new persistor
    storage.store_temporary stream, id

    assert persistor.verify
  end

  def test_store_permanent
    stream = StringIO.new 'test'
    id = MountableFileServer::Identifier.new 'public-test.txt'
    pathname = MountableFileServer::FileAccessor.new(id).permanent_pathname

    persistor = MiniTest::Mock.new
    persistor.expect :new, persistor, [pathname]
    persistor.expect :save, nil, [stream]

    storage = MountableFileServer::Storage.new persistor
    storage.store_permanent stream, id

    assert persistor.verify
  end

  def test_remove_from_permanent_storage
    id = MountableFileServer::Identifier.new 'public-test.txt'
    pathname = MountableFileServer::FileAccessor.new(id).permanent_pathname

    persistor = MiniTest::Mock.new
    persistor.expect :new, persistor, [pathname]
    persistor.expect :delete, nil, []

    storage = MountableFileServer::Storage.new persistor
    storage.remove_from_permanent_storage id

    assert persistor.verify
  end

  def test_move_to_permanent_storage
    id = MountableFileServer::Identifier.new 'public-test.txt'
    pathname_a = MountableFileServer::FileAccessor.new(id).temporary_pathname
    pathname_b = MountableFileServer::FileAccessor.new(id).permanent_pathname

    persistor = MiniTest::Mock.new
    persistor.expect :new, persistor, [pathname_a]
    persistor.expect :rename, nil, [pathname_b]

    storage = MountableFileServer::Storage.new persistor
    storage.move_to_permanent_storage id

    assert persistor.verify
  end
end
