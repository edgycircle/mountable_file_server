require 'unit_helper'

class URITest < UnitTestCase
  URI = MountableFileServer::URI
  UniqueIdentifier = MountableFileServer::UniqueIdentifier

  def test_acts_like_a_string
    uri = URI.new '/uploads/public-test.jpg'
    assert_equal '/uploads/public-test.jpg', uri
  end

  def test_extract_uid
    uri = URI.new '/uploads/public-test.jpg'

    assert_instance_of UniqueIdentifier, uri.uid
    assert_equal 'public-test.jpg', uri.uid
  end
end
