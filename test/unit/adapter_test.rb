require 'unit_helper'
require 'mocha/minitest'
require 'stringio'
require 'pathname'

class AdapterTest < UnitTestCase
  UniqueIdentifier = MountableFileServer::UniqueIdentifier
  Adapter = MountableFileServer::Adapter

  class Configuration
    attr_reader :base_url, :storage_path

    def initialize(base_url, storage_path = '')
      @base_url = base_url
      @storage_path = storage_path
    end
  end

  def setup
    @stored_at = Dir.mktmpdir
  end

  def teardown
    Pathname(@stored_at).rmtree
  end

  def test_uid_within_directories_when_storing_temporary
    io = StringIO.new 'test'
    adapter = Adapter.new configuration
    random_identifiers = [
      UniqueIdentifier.new('public-a.txt'),
      UniqueIdentifier.new('public-a.txt'),
      UniqueIdentifier.new('public-b.txt')
    ]
    UniqueIdentifier.stubs(:generate_for).returns(*random_identifiers)

    identifier_a = adapter.store_temporary io, 'public', '.txt'
    identifier_b = adapter.store_temporary io, 'public', '.txt'

    assert_equal 'public-a.txt', identifier_a
    assert_equal 'public-b.txt', identifier_b
  end

  def test_uid_within_directories_when_storing_permanent
    io = StringIO.new 'test'
    adapter = Adapter.new configuration
    random_identifiers = [
      UniqueIdentifier.new('public-a.txt'),
      UniqueIdentifier.new('public-a.txt'),
      UniqueIdentifier.new('public-b.txt')
    ]
    UniqueIdentifier.stubs(:generate_for).returns(*random_identifiers)

    identifier_a = adapter.store_permanent io, 'public', '.txt'
    identifier_b = adapter.store_permanent io, 'public', '.txt'

    assert_equal 'public-a.txt', identifier_a
    assert_equal 'public-b.txt', identifier_b
  end

  def test_url_of_public_uid_is_returned
    configuration = Configuration.new '/abc'

    [
      'public-test.png',
      UniqueIdentifier.new('public-test.png')
    ].each do |uid|
      assert_equal '/abc/public-test.png', Adapter.new(configuration).url_for(uid)
    end
  end

  def test_private_uids_do_not_have_urls
    [
      'private-test.png',
      UniqueIdentifier.new('private-test.png')
    ].each do |uid|
      assert_raises(MountableFileServer::NotAccessibleViaURL) do
        Adapter.new.url_for(uid)
      end
    end
  end

  def test_path_for_object_uid_is_returned
    [
      { directory: 'tmp', filename: 'public-' },
      { directory: 'tmp', filename: 'private-' },
      { directory: 'public', filename: 'public-' },
      { directory: 'private', filename: 'private-' }
    ].each do |combination|
      Dir.mktmpdir do |directory|
        path = Pathname(directory) + combination[:directory]
        path.mkpath
        configuration = Configuration.new '', directory

        Tempfile.open(combination[:filename], path) do |file|
          uid = UniqueIdentifier.new File.basename(file)

          assert_equal Pathname(file.path), Adapter.new(configuration).pathname_for(uid)
        end
      end
    end
  end

  def test_path_for_string_uid_is_returned
    [
      { directory: 'tmp', filename: 'public-' },
      { directory: 'tmp', filename: 'private-' },
      { directory: 'public', filename: 'public-' },
      { directory: 'private', filename: 'private-' }
    ].each do |combination|
      Dir.mktmpdir do |directory|
        path = Pathname(directory) + combination[:directory]
        path.mkpath
        configuration = Configuration.new '', directory

        Tempfile.open(combination[:filename], path) do |file|
          uid = File.basename(file)

          assert_equal Pathname(file.path), Adapter.new(configuration).pathname_for(uid)
        end
      end
    end
  end

  private
  def configuration
    Configuration.new '', @stored_at
  end
end
