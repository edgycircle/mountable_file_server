require 'unit_helper'
require 'tempfile'
require 'pathname'

class FileAccessorTest < UnitTestCase
  def test_temporary_pathname_of_public_id
    id = MountableFileServer::Identifier.new 'public-test.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_equal Pathname('/tmp/public-test.jpg'), file_acccessor.temporary_pathname
  end

  def test_temporary_pathname_of_private_id
    id = MountableFileServer::Identifier.new 'private-test.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_equal Pathname('/tmp/private-test.jpg'), file_acccessor.temporary_pathname
  end

  def test_permanent_pathname_of_public_id
    id = MountableFileServer::Identifier.new 'public-test.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_equal Pathname('/public/public-test.jpg'), file_acccessor.permanent_pathname
  end

  def test_permanent_pathname_of_private_id
    id = MountableFileServer::Identifier.new 'private-test.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_equal Pathname('/private/private-test.jpg'), file_acccessor.permanent_pathname
  end

  def test_pathname_of_public_id_in_temporary_storage
    Dir.mktmpdir do |directory|
      temporary_path = Pathname(directory) + 'tmp'
      temporary_path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('public-', temporary_path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert_equal Pathname(file.path), file_acccessor.pathname
      end
    end
  end

  def test_pathname_of_private_id_in_temporary_storage
    Dir.mktmpdir do |directory|
      temporary_path = Pathname(directory) + 'tmp'
      temporary_path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('private-', temporary_path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert_equal Pathname(file.path), file_acccessor.pathname
      end
    end
  end

  def test_pathname_of_public_id_in_permanent_storage
    Dir.mktmpdir do |directory|
      permanent_path = Pathname(directory) + 'public'
      permanent_path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('public-', permanent_path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert_equal Pathname(file.path), file_acccessor.pathname
      end
    end
  end

  def test_pathname_of_private_id_in_permanent_storage
    Dir.mktmpdir do |directory|
      permanent_path = Pathname(directory) + 'private'
      permanent_path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('private-', permanent_path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert_equal Pathname(file.path), file_acccessor.pathname
      end
    end
  end

  def test_pathname_raises_error_for_id_without_file
    id = MountableFileServer::Identifier.new 'public-unknown.jpg'
    file_acccessor = MountableFileServer::FileAccessor.new id, configuration

    assert_raises(MountableFileServer::NoFileForIdentifier) { file_acccessor.pathname }
  end

  def test_exist_returns_false_for_unknown_id
    id = MountableFileServer::Identifier.new 'public-unknown.jpg'
    refute MountableFileServer::FileAccessor.new(id).exist?
  end

  def test_exist_returns_true_for_id_of_public_file_in_temporary_storage
    Dir.mktmpdir do |directory|
      path = Pathname(directory) + 'tmp'
      path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('public-', path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert file_acccessor.exist?
      end
    end
  end

  def test_exist_returns_true_for_id_of_private_file_in_temporary_storage
    Dir.mktmpdir do |directory|
      path = Pathname(directory) + 'tmp'
      path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('private-', path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert file_acccessor.exist?
      end
    end
  end

  def test_exist_returns_true_for_id_of_public_file_in_permanent_storage
    Dir.mktmpdir do |directory|
      path = Pathname(directory) + 'public'
      path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('public-', path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

        assert file_acccessor.exist?
      end
    end
  end

  def test_exist_returns_true_for_id_of_private_file_in_permanent_storage
    Dir.mktmpdir do |directory|
      path = Pathname(directory) + 'private'
      path.mkpath
      configuration = MountableFileServer::Configuration.new stored_at: directory

      Tempfile.open('private-', path) do |file|
        id = MountableFileServer::Identifier.new File.basename(file)
        file_acccessor = MountableFileServer::FileAccessor.new id, configuration

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

  def test_private_ids_do_not_have_urls
    id = MountableFileServer::Identifier.new 'private-test.png'
    file_acccessor = MountableFileServer::FileAccessor.new id

    assert_raises(MountableFileServer::NotAccessibleViaURL) do
      file_acccessor.url
    end
  end

  private
  def configuration
    MountableFileServer::Configuration.new stored_at: '/'
  end
end
