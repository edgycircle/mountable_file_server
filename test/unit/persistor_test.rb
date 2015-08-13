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
    source = Tempfile.new('test')
    source.write 'test'
    source.close

    Tempfile.open('test') do |file|
      persistor = MountableFileServer::Persistor.new file.path
      persistor.save source.path

      assert_equal 'test', file.read
    end

    source.unlink
  end
end
