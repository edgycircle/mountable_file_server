require 'unit_helper'

class IdentifierTest < UnitTestCase
  Identifier = MountableFileServer::Identifier

  def test_generate_id_for_extension
    id = Identifier.generate_for '.png', 'public'
    assert_match /\w+\.png$/, id
  end

  def test_generate_public_id
    id = Identifier.generate_for '.png', 'public'
    assert_match /^public-\w+/, id
  end

  def test_generate_private_id
    id = Identifier.generate_for '.png', 'private'
    assert_match /^private-\w+/, id
  end

  def test_generate_accepts_only_known_types
    assert_raises(MountableFileServer::UnknownType) do
      Identifier.generate_for '.png', 'unknow'
    end
  end

  def test_generate_returns_new_id
    assert_instance_of Identifier, Identifier.generate_for('.png', 'public')
  end

  def test_instantiation_with_string
    assert Identifier.new 'public-test.png'
  end

  def test_instantiation_with_id
    assert Identifier.new Identifier.new('public-test.png')
  end

  def test_instantiation_accepts_only_known_types
    assert_raises(MountableFileServer::UnknownType) do
      Identifier.new 'unknown-test.png'
    end
  end

  def test_knows_if_id_is_public
    assert Identifier.new('public-test.png').public?
    refute Identifier.new('private-test.png').public?
  end
end
