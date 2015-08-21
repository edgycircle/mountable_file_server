require 'integration_helper'
require 'json'

class TestNormalTesting < IntegrationTestCase
  def setup
    @stored_at = Dir.mktmpdir
  end

  def teardown
    Pathname(@stored_at).rmtree
  end

  def test_upload_of_public_file_returns_uid
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'public'
    assert_match /public-.*.jpg/, last_response.body
  end

  def test_upload_of_private_file_returns_uid
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'private'
    assert_match /private-.*.jpg/, last_response.body
  end

  def test_upload_of_public_file_stores_it_temporarly
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'public'
    result = JSON.parse(last_response.body)
    assert File.file?(File.join(configuration.stored_at, 'tmp', result['uid']))
  end

  def test_public_files_are_accessible
    uid = adapter.store_permanent fixture_path('david.jpg'), 'public', '.jpg'
    get uid
    assert_equal 200, last_response.status
  end

  def test_private_files_are_not_accessible
    uid = adapter.store_permanent fixture_path('david.jpg'), 'private', '.jpg'
    get uid
    assert_equal 404, last_response.status
  end

  private
  def adapter
    MountableFileServer::Adapter.new configuration
  end

  def configuration
    MountableFileServer::Configuration.new '', @stored_at
  end

  def app
    MountableFileServer::Endpoint.new configuration
  end
end
