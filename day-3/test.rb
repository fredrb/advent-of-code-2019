require "minitest/autorun"
require_relative "./main"

class Day3Test < Minitest::Test

  def setup
    @panel = FrontPanel.new(100)
  end

  def test_can_test
    assert_equal true, true
  end 

  def test_simple_example
    input = [
      ["R8","U5","L5","D3"],
      ["U7","R6","D4","L4"]
    ]
    @panel.add_wires input
    assert_equal @panel.get_closest_cross, 6
  end

end