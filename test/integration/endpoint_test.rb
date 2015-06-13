require 'integration_helper'

class TestNormalTesting < IntegrationTestCase
  def setup
    FileUtils.mkdir_p configuration.stored_at
    FileUtils.mkdir_p File.join(configuration.stored_at, 'tmp')
    FileUtils.mkdir_p File.join(configuration.stored_at, 'public')
    FileUtils.mkdir_p File.join(configuration.stored_at, 'private')
  end

  def teardown
    FileUtils.rm_rf configuration.stored_at
  end

  def test_upload_of_public_file_returns_identifier
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'public'
    assert_match /public-.*.jpg/, last_response.body
  end

  def test_upload_of_private_file_returns_identifier
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'private'
    assert_match /private-.*.jpg/, last_response.body
  end

  def test_upload_of_public_file_stores_it_temporarly
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'public'
    assert File.file?(File.join(configuration.stored_at, 'tmp', last_response.body))
  end

  def test_public_files_are_accessible
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'public'

    identifier = last_response.body
    storage.move_to_permanent_storage identifier: identifier

    get "/#{identifier.gsub('public-', '')}"
    assert_equal 200, last_response.status
  end

  def test_private_files_are_not_accessible
    post '/', file: Rack::Test::UploadedFile.new(fixture_path('david.jpg'), 'image/jpeg'), type: 'private'

    identifier = last_response.body
    storage.move_to_permanent_storage identifier: identifier

    get "/#{identifier.gsub('private-', '')}"
    assert_equal 404, last_response.status
  end

private
  def storage
    MountableFileServer::Storage.new configuration
  end

  def configuration
    MountableFileServer::Configuration.new mounted_at: '', stored_at: File.expand_path('../../tmp/test-uploads/', File.dirname(__FILE__))
  end

  def app
    MountableFileServer::Endpoint.new configuration
  end
end
