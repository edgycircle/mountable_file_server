require 'unit_helper'
require 'stringio'
require 'pathname'

class AdapterTest < UnitTestCase
  Configuration = MountableFileServer::Configuration
  Identifier = MountableFileServer::Identifier
  Adapter = MountableFileServer::Adapter

  def setup
    @stored_at = Dir.mktmpdir
  end

  def teardown
    Pathname(@stored_at).rmtree
  end

  def test_unique_identifier_within_directories_when_storing_temporary
    io = StringIO.new 'test'
    adapter = MountableFileServer::Adapter.new configuration
    random_identifiers = [
      MountableFileServer::Identifier.new('public-a.txt'),
      MountableFileServer::Identifier.new('public-a.txt'),
      MountableFileServer::Identifier.new('public-b.txt')
    ]
    stub(MountableFileServer::Identifier).generate_for('.txt', 'public') { random_identifiers.shift }

    identifier_a = adapter.store_temporary io, 'public', '.txt'
    identifier_b = adapter.store_temporary io, 'public', '.txt'

    assert_equal 'public-a.txt', identifier_a
    assert_equal 'public-b.txt', identifier_b
  end

  def test_unique_identifier_within_directories_when_storing_permanent
    io = StringIO.new 'test'
    adapter = MountableFileServer::Adapter.new configuration
    random_identifiers = [
      MountableFileServer::Identifier.new('public-a.txt'),
      MountableFileServer::Identifier.new('public-a.txt'),
      MountableFileServer::Identifier.new('public-b.txt')
    ]
    stub(MountableFileServer::Identifier).generate_for('.txt', 'public') { random_identifiers.shift }

    identifier_a = adapter.store_permanent io, 'public', '.txt'
    identifier_b = adapter.store_permanent io, 'public', '.txt'

    assert_equal 'public-a.txt', identifier_a
    assert_equal 'public-b.txt', identifier_b
  end






  def test_url_of_public_id_is_returned
    configuration = Configuration.new mounted_at: '/abc'

    [
      'public-test.png',
      Identifier.new('public-test.png')
    ].each do |id|
      assert_equal '/abc/public-test.png', Adapter.new(configuration).url_for(id)
    end
  end

  def test_private_ids_do_not_have_urls
    [
      'private-test.png',
      Identifier.new('private-test.png')
    ].each do |id|
      assert_raises(MountableFileServer::NotAccessibleViaURL) do
        Adapter.new.url_for(id)
      end
    end
  end

  def test_path_for_object_id_is_returned
    [
      { directory: 'tmp', filename: 'public-' },
      { directory: 'tmp', filename: 'private-' },
      { directory: 'public', filename: 'public-' },
      { directory: 'private', filename: 'private-' }
    ].each do |combination|
      Dir.mktmpdir do |directory|
        path = Pathname(directory) + combination[:directory]
        path.mkpath
        configuration = MountableFileServer::Configuration.new stored_at: directory

        Tempfile.open(combination[:filename], path) do |file|
          id = MountableFileServer::Identifier.new File.basename(file)

          assert_equal Pathname(file.path), Adapter.new(configuration).pathname_for(id)
        end
      end
    end
  end

  def test_path_for_string_id_is_returned
    [
      { directory: 'tmp', filename: 'public-' },
      { directory: 'tmp', filename: 'private-' },
      { directory: 'public', filename: 'public-' },
      { directory: 'private', filename: 'private-' }
    ].each do |combination|
      Dir.mktmpdir do |directory|
        path = Pathname(directory) + combination[:directory]
        path.mkpath
        configuration = MountableFileServer::Configuration.new stored_at: directory

        Tempfile.open(combination[:filename], path) do |file|
          id = File.basename(file)

          assert_equal Pathname(file.path), Adapter.new(configuration).pathname_for(id)
        end
      end
    end
  end

  private
  def configuration
    MountableFileServer::Configuration.new stored_at: @stored_at
  end
end
