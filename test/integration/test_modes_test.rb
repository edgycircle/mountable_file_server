require 'integration_helper'

class TestTestModes < IntegrationTestCase
  include MountableFileServer::StorageHelper

  def setup
    MountableFileServer.testing!
  end

  def teardown
    MountableFileServer.remove_files!
    MountableFileServer.default!
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
end
