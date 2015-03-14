require 'integration_helper'
require 'mountable_file_server/testing'

class TestFakeTesting < IntegrationTestCase
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

  def test_requesting_uploads_returns_fake_uploades
    MountableFileServer::Testing.fake_upload = File.open(path('david.jpg'))

    get '/non-existing.jpg'
    assert_equal File.open(path('david.jpg')).size, last_response.body.size
    assert_equal File.binread(path('david.jpg')), last_response.body
  end
end
