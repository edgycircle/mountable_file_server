require 'unit_helper'

class UploadTest < MiniTest::Test
  def test_read_file
    file = File.new(File.expand_path(File.join('../fixtures', 'david.jpg'), File.dirname(__FILE__)))
    read_file = File.new(File.expand_path(File.join('../fixtures', 'david.jpg'), File.dirname(__FILE__))).read
    upload = MountableFileServer::Upload.new file: { tempfile: file }, type: 'public'

    read_one = upload.read
    read_two = upload.read

    assert_equal read_file, read_one
    assert_equal read_two, read_one
  end
end
