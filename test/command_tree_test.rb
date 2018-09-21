require "test_helper"

class TreeTest < Minitest::Test
  def test_it_respond_to_register
    assert ::CommandTree::Tree.new.respond_to?(:register)
  end

  def test_it_respond_to_show
    assert ::CommandTree::Tree.new.respond_to?(:show)
  end
end
