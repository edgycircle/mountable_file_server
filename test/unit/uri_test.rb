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

  def test_encoded_processing_instructions
    uri = URI.new '/uploads/public-test.YWJjREVG.jpg'
    assert_equal 'YWJjREVG', uri.encoded_processing_instructions
  end

  def test_decoded_processing_instructions
    uri = URI.new '/uploads/public-test.YWJjREVG.jpg'
    assert_equal 'abcDEF', uri.decoded_processing_instructions
  end

  def test_generate_new_url_with_processing_instructions
    uri = URI.new '/uploads/public-test.jpg'
    resized_uri = uri.resize 'abcDEF'

    assert_instance_of URI, resized_uri
    assert_equal '/uploads/public-test.YWJjREVG.jpg', resized_uri
  end
end
