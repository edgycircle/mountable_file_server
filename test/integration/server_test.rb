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
    assert_match(/public-\w{32}\.png/, result[:fid])
    assert_equal "http://test.test/uploads/#{result[:fid]}", result[:url]
    assert_equal File.size(fixture_path('image.png')), result[:metadata][:size]
    assert_equal 'image/png', result[:metadata][:content_type]
    assert_equal 269, result[:metadata][:width]
    assert_equal 234, result[:metadata][:height]
  end

  def test_private_file_upload
    post '/', {
      file: Rack::Test::UploadedFile.new(fixture_path('image.png'), 'image/jpeg'),
      type: 'private'
    }

    result = JSON.parse(last_response.body, symbolize_names: true)

    assert_equal 201, last_response.status
    assert_equal 'application/json', last_response.headers['Content-Type']
    assert_match(/private-\w{32}\.png/, result[:fid])
    assert_equal nil, result[:url]
    assert_equal File.size(fixture_path('image.png')), result[:metadata][:size]
    assert_equal 'image/png', result[:metadata][:content_type]
    assert_equal 269, result[:metadata][:width]
    assert_equal 234, result[:metadata][:height]
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

  def test_download_of_unknown_fid
    fid = 'public-unknown.png'
    get fid

    assert_equal 404, last_response.status
  end

  def test_download_of_malformed_fid
    fid = 'bla.png'
    get fid

    assert_equal 404, last_response.status
  end
end
