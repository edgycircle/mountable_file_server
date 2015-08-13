require 'unit_helper'
require 'stringio'
require 'tempfile'
require 'pathname'

class PersistorTest < UnitTestCase
  def test_creates_directories
    Dir.mktmpdir do |directory|
      pathname = Pathname.new(directory) + 'level-1' + 'level-2' + 'test.txt'
      persistor = MountableFileServer::Persistor.new pathname

      persistor.save StringIO.new('test')

      assert_equal 'test', pathname.read
    end
  end

  def test_save_io_to_pathname
    Tempfile.open('test') do |file|
      persistor = MountableFileServer::Persistor.new file.path

      persistor.save StringIO.new('test')

      assert_equal 'test', file.read
    end
  end

  def test_save_pathname_to_pathname
    io = Tempfile.new('test')
    io.write 'test'
    io.close

    Tempfile.open('test') do |file|
      persistor = MountableFileServer::Persistor.new file.path
      persistor.save io.path

      assert_equal 'test', file.read
    end

    io.unlink
  end

  def test_delete_pathname
    file = Tempfile.new 'test'

    persistor = MountableFileServer::Persistor.new file.path
    persistor.delete

    refute Pathname(file.path).exist?
  end

  def test_rename_pathname
    file = Tempfile.new 'test'
    file.write 'test'
    file.close

    new_pathname = Pathname(file.path).dirname + 'test-2'

    persistor = MountableFileServer::Persistor.new file.path
    persistor.rename new_pathname

    refute Pathname(file.path).exist?
    assert new_pathname.exist?
    assert_equal 'test', new_pathname.read
  end
end
