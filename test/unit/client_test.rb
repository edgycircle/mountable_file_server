require 'unit_helper'
require 'webmock'

require 'mountable_file_server/client'

class ClientTest < UnitTestCase
  include WebMock::API

  Client = MountableFileServer::Client

  def setup
    WebMock.enable!

    MountableFileServer.configure do |config|
      config.base_url = 'http://test.test/uploads/'
    end
  end

  def teardown
    WebMock.disable!
  end

  def test_move_to_permanent_storage
    fid = 'public-123.png'
    subject = Client.new

    stub_request(:post, 'http://test.test/uploads/public-123.png/store-permanent')
    subject.move_to_permanent_storage(fid)

    assert_requested :post, "http://test.test/uploads/#{fid}/store-permanent", times: 1
  end

  def test_remove_from_storage
    fid = 'public-123.png'
    subject = Client.new

    stub_request(:delete, 'http://test.test/uploads/public-123.png')
    subject.remove_from_storage(fid)

    assert_requested :delete, "http://test.test/uploads/#{fid}", times: 1
  end

  def test_url_for
    fid = 'public-123.png'
    subject = Client.new

    assert_equal 'http://test.test/uploads/public-123.png', subject.url_for(fid)
  end
end
