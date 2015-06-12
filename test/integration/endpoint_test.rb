require 'integration_helper'

class TestNormalTesting < IntegrationTestCase
  def setup
    FileUtils.mkdir_p configuration.stored_at
    FileUtils.mkdir_p File.join(configuration.stored_at, 'tmp')
  end

  def teardown
    FileUtils.rm_rf configuration.stored_at
  end

  def test_upload_of_public_file_returns_identifier
    post '/', file: Rack::Test::UploadedFile.new(path('david.jpg'), 'image/jpeg'), type: 'public'
    assert_match /public-.*.jpg/, last_response.body
  end

  def test_upload_of_private_file_returns_identifier
    post '/', file: Rack::Test::UploadedFile.new(path('david.jpg'), 'image/jpeg'), type: 'private'
    assert_match /private-.*.jpg/, last_response.body
  end

  def test_upload_of_public_file_stores_it_temporarly
    post '/', file: Rack::Test::UploadedFile.new(path('david.jpg'), 'image/jpeg'), type: 'public'
    assert File.file?(File.join(configuration.stored_at, 'tmp', last_response.body))
  end

private
  def configuration
    MountableFileServer::Configuration.new mounted_at: '', stored_at: File.expand_path('../../tmp/test-uploads/', File.dirname(__FILE__))
  end

  def app
    MountableFileServer::Endpoint.new configuration
  end
end
