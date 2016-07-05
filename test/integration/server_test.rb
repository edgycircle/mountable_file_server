require 'integration_helper'
require 'json'

class TestServer < IntegrationTestCase
  def setup
    MountableFileServer.configure do |config|
      config.base_url = 'http://test.test/uploads/'
      config.storage_path = Dir.mktmpdir
    end
  end

  def teardown
    Pathname(MountableFileServer.config.storage_path).rmtree
  end

  def test_file_upload
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'public'
    }

    result = JSON.parse(last_response.body, symbolize_names: true)

    assert_equal 201, last_response.status
    assert_equal 'application/json', last_response.headers['Content-Type']
    assert_match /public-\w{32}\.png/, result[:fid]
    assert_equal "http://test.test/uploads/#{result[:fid]}", result[:url]
    assert_equal File.size(fixture_path('image.png')), result[:metadata][:size]
    assert_equal 'image/png', result[:metadata][:content_type]
    assert_equal 62, result[:metadata][:width]
    assert_equal 62, result[:metadata][:height]
  end

  def test_temporary_file_download
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'public'
    }

    fid = JSON.parse(last_response.body, symbolize_names: true)[:fid]
    get fid

    Dir.mktmpdir('downloads') do |dir|
      File.open(File.join(dir, 'test.png'), 'wb') { |file| file.write(last_response.body) }
      assert_equal Pathname(fixture_path('image.png')).read, Pathname(File.join(dir, 'test.png')).read
    end
  end

  def test_permanent_storage
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'public'
    }

    fid = JSON.parse(last_response.body, symbolize_names: true)[:fid]
    post fid + '/store-permanent'

    assert_equal 200, last_response.status
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_permanent_file_download
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'public'
    }

    fid = JSON.parse(last_response.body, symbolize_names: true)[:fid]
    post fid + '/store-permanent'
    get fid

    Dir.mktmpdir('downloads') do |dir|
      File.open(File.join(dir, 'test.png'), 'wb') { |file| file.write(last_response.body) }
      assert_equal Pathname(fixture_path('image.png')).read, Pathname(File.join(dir, 'test.png')).read
    end
  end

  def test_file_deletion
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'public'
    }

    fid = JSON.parse(last_response.body, symbolize_names: true)[:fid]
    delete fid

    assert_equal 200, last_response.status
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_purge_temporary_storage
    skip 'Needs implementation'
  end

  def test_storage_statistics
    skip 'Needs implementation'
  end
end
