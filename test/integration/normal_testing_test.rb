require 'integration_helper'
require 'mountable_file_server/testing'

class TestNormalTesting < IntegrationTestCase
  include MountableFileServer::StorageHelper

  def setup
    super
    MountableFileServer::Testing.enable!
  end

  def teardown
    MountableFileServer::Testing.remove_uploads!
  end

  def test_uploading_public_file_returns_file_identifier
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    assert_match /public-.*.jpg/, last_response.body
  end

  def test_uploading_public_file_stores_it_temporarly
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    assert File.file? File.join(MountableFileServer.configuration.stored_at, 'tmp', last_response.body)
  end

  def test_temporary_stored_file_can_be_moved_to_permanent_storage
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    assert File.file? File.join(MountableFileServer.configuration.stored_at, 'tmp', last_response.body)
    move_upload_to_storage last_response.body
    assert File.file? File.join(MountableFileServer.configuration.stored_at, 'public', last_response.body)
    refute File.file? File.join(MountableFileServer.configuration.stored_at, 'tmp', last_response.body)
  end

  def test_uploads_are_accessible
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    move_upload_to_storage last_response.body

    get "/#{last_response.body}"
    assert_equal File.open(path('david.jpg')).size, last_response.body.size
    assert_equal File.binread(path('david.jpg')), last_response.body
  end

  def test_fixture_uploads_are_supported
    MountableFileServer::Testing.fixture_pathname = File.expand_path('../../fixtures', __FILE__)

    get '/david.jpg'
    assert_equal File.open(path('david.jpg')).size, last_response.body.size
    assert_equal File.binread(path('david.jpg')), last_response.body
  end
end
