require 'unit_helper'

class UniqueIdentifierTest < UnitTestCase
  UniqueIdentifier = MountableFileServer::UniqueIdentifier

  def test_generate_uid_for_extension
    uid = UniqueIdentifier.generate_for 'public', '.png'
    assert_match /\w+\.png$/, uid
  end

  def test_generate_public_uid
    uid = UniqueIdentifier.generate_for 'public', '.png'
    assert_match /^public-\w+/, uid
  end

  def test_generate_private_uid
    uid = UniqueIdentifier.generate_for 'private', '.png'
    assert_match /^private-\w+/, uid
  end

  def test_generate_accepts_only_known_types
    assert_raises(MountableFileServer::UnknownType) do
      UniqueIdentifier.generate_for 'unknow', '.png'
    end
  end

  def test_generate_returns_new_uid
    assert_instance_of UniqueIdentifier, UniqueIdentifier.generate_for('public', '.png')
  end

  def test_instantiation_with_string
    assert UniqueIdentifier.new 'public-test.png'
  end

  def test_instantiation_with_uid
    assert UniqueIdentifier.new UniqueIdentifier.new('public-test.png')
  end

  def test_instantiation_accepts_only_known_types
    assert_raises(MountableFileServer::UnknownType) do
      UniqueIdentifier.new 'unknown-test.png'
    end
  end

  def test_knows_if_uid_is_public
    assert UniqueIdentifier.new('public-test.png').public?
    refute UniqueIdentifier.new('private-test.png').public?
  end
end
