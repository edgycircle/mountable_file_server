require 'unit_helper'

class AccessTest < UnitTestCase
  def test_temporary_path_with_identifier_string
    expected_path = '~/tmp/public-test.png'
    actual_path = access.temporary_path_for identifier: 'public-test.png'
    assert_equal expected_path, actual_path
  end

  def test_temporary_path_with_identifier_object
    identifier = MountableFileServer::Identifier.new 'public-test.png'
    expected_path = '~/tmp/public-test.png'
    actual_path = access.temporary_path_for identifier: identifier
    assert_equal expected_path, actual_path
  end

  def test_path_for_with_public_identifier_string
    expected_path = '~/public/test.png'
    actual_path = access.path_for identifier: 'public-test.png'
    assert_equal expected_path, actual_path
  end

  def test_path_for_with_private_identifier_string
    expected_path = '~/private/test.png'
    actual_path = access.path_for identifier: 'private-test.png'
    assert_equal expected_path, actual_path
  end

  def test_path_for_with_public_identifier_object
    identifier = MountableFileServer::Identifier.new 'public-test.png'
    expected_path = '~/public/test.png'
    actual_path = access.path_for identifier: identifier
    assert_equal expected_path, actual_path
  end

  def test_path_for_with_private_identifier_object
    identifier = MountableFileServer::Identifier.new 'private-test.png'
    expected_path = '~/private/test.png'
    actual_path = access.path_for identifier: identifier
    assert_equal expected_path, actual_path
  end

  def test_url_for_with_public_string
    expected_url = '/uploads/test.png'
    actual_url = access.url_for identifier: 'public-test.png'
    assert_equal expected_url, actual_url
  end

  def test_url_for_with_public_object
    identifier = MountableFileServer::Identifier.new 'public-test.png'
    expected_url = '/uploads/test.png'
    actual_url = access.url_for identifier: identifier
    assert_equal expected_url, actual_url
  end

  def test_private_identifier_strings_do_not_have_an_url
    identifier = 'private-test.png'
    assert_raises(MountableFileServer::Access::NotAccessibleViaURL) do
      access.url_for(identifier: identifier)
    end
  end

  def test_private_identifier_objects_do_not_have_an_url
    identifier = MountableFileServer::Identifier.new 'private-test.png'
    assert_raises(MountableFileServer::Access::NotAccessibleViaURL) do
      access.url_for(identifier: identifier)
    end
  end

  private
  def configuration
    MountableFileServer::Configuration.new mounted_at: '/uploads', stored_at: '~/'
  end

  def access
    MountableFileServer::Access.new configuration
  end
end
