require 'matrix'
require 'set'
require_relative '../lib/bot/flip'
require 'pry'
require "test/unit"

class TestGrid < Test::Unit::TestCase
  def setup
    @grid = Grid.new
  end

  def test_rotate_90
    original_data = [
      [0.0, 0.1, 0.2, 0.3],
      [1.0, 1.1, 1.2, 1.3],
      [2.0, 2.1, 2.2, 2.3],
      [3.0, 3.1, 3.2, 3.3]
    ]

    expect = [
      [3.0, 2.0, 1.0, 0.0],
      [3.1, 2.1, 1.1, 0.1],
      [3.2, 2.2, 1.2, 0.2],
      [3.3, 2.3, 1.3, 0.3]
    ]

    response = @grid.rotate_90(original_data)

    assert_equal(expect, response, "it should rotate 90")
  end

  def test_rotate_180
    original_data = [
      [1, 1, 1, 1],
      [0, 1, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ]

    expect = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 1, 0],
      [1, 1, 1, 1]
    ]

    response = @grid.rotate_180(original_data)

    assert_equal(expect, response, "it should rotate 180")
  end

    def test_rotate_270
    original_data = [
      [1, 1, 1, 1],
      [0, 1, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ]

    expect = [
      [1, 0, 0, 0],
      [1, 0, 0, 0],
      [1, 1, 0, 0],
      [1, 0, 0, 0]
    ]

    response = @grid.rotate_270(original_data)

    assert_equal(expect, response, "it should rotate 270")
  end
end