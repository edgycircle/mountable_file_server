require 'unit_helper'

class UploadTest < UnitTestCase
  def test_read_file
    file = File.new(fixture_path('david.jpg'))
    read_file = File.new(fixture_path('david.jpg')).read
    upload = MountableFileServer::Upload.new file: { tempfile: file }, type: 'public'

    read_one = upload.read
    read_two = upload.read

    assert_equal read_file, read_one
    assert_equal read_two, read_one
  end
end
