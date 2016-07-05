require 'unit_helper'

require 'mountable_file_server/metadata'

class MetadataTest < UnitTestCase
  Metadata = MountableFileServer::Metadata

  def test_size
    subject = Metadata.for_path(fixture_path('image.png'))
    result = subject.size
    assert_equal File.size(fixture_path('image.png')), result
  end

  def test_content_type
    subject = Metadata.for_path(fixture_path('image.png'))
    result = subject.content_type
    assert_equal 'image/png', result
  end

  def test_image_height
    subject = Metadata.for_path(fixture_path('image.png'))
    result = subject.height
    assert_equal 62, result
  end

  def test_image_width
    subject = Metadata.for_path(fixture_path('image.png'))
    result = subject.width
    assert_equal 62, result
  end

  def test_image_hash
    subject = Metadata.for_path(fixture_path('image.png'))
    result = subject.to_h
    assert_equal({
      content_type: 'image/png',
      size: File.size(fixture_path('image.png')),
      height: 62,
      width: 62
    }, result)
  end

  def test_non_image_hash
    subject = Metadata.for_path(fixture_path('test.txt'))
    result = subject.to_h
    assert_equal({
      content_type: 'text/plain',
      size: File.size(fixture_path('test.txt'))
    }, result)
  end
end
