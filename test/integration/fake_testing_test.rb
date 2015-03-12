require 'integration_helper'
require 'mountable_file_server/testing'

class TestFakeTesting < IntegrationTestCase
  include MountableFileServer::StorageHelper

  def setup
    super
    MountableFileServer::Testing.fake!
  end

  def teardown
    MountableFileServer::Testing.disable!
  end

  def test_returns_fake_upload_identifier
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    assert_equal 'public-fake.png', last_response.body
  end

  def test_upload_is_not_stored
    post "/public-upload", file: Rack::Test::UploadedFile.new(path('david.jpg'), "image/jpeg")
    assert Dir["#{MountableFileServer.configuration.stored_at}/public/*"].empty?
    assert Dir["#{MountableFileServer.configuration.stored_at}/tmp/*"].empty?
  end
end
