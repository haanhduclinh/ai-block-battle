require 'matrix'
require_relative '../lib/bot/game_matrix'
require 'pry'
require "test/unit"

class TestGameMatrix < Test::Unit::TestCase

  def setup
    @matrix = GameMatrix.new
  end

  def test_build_matrix_from_start_point
    input_matrix = [
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 0, 0],
      [1, 0, 0, 0]
    ]

    response = @matrix.build_matrix_from_start_point(input_matrix, [0,1], [2,2])
    expect = [[0, 0], [0, 1]]
    assert_equal(response, expect, "not same")
  end

  def test_valid_matrix
    m1 = Matrix[ [1, 2, 3], [3, 2, 1], [1, 1, 1] ]
    m2 = Matrix[ [2, 2, 1], [3, 2, 3], [1, 1, 3] ]

    sum = m1 + m2
    response = @matrix.valid_matrix?(sum)
    assert_equal(response, false, "it should invalid")
  end

  def test_merge_array
    input_matrix = [
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ]

    with_array = [
      [1, 1],
      [1, 1]
    ]

    land_pos = [2, 2]

    expected_array = [
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 1],
      [0, 0, 1, 1]
    ]

    response = @matrix.merge_array(input_matrix, with_array, land_pos)
    assert_equal(response, expected_array, "it should same")
  end

  def test_matrix_after_land
    input_matrix = [
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ]

    character_matrix = [
      [1, 1],
      [1, 1]
    ]

    expected_array = [
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 1],
      [0, 0, 1, 1]
    ]

    land_pos = [2, 2]

    response = @matrix.matrix_after_land(input_matrix, character_matrix, land_pos)
    assert_equal(response, expected_array, "it should same")
  end

  def test_find_path
    current_post = [3, -1]
    character_matrix = [
      [0, 0, 0, 0],
      [1, 1, 1, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ]

    original_matrix = [
      [0, 0, 0, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 2, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 2, 2, 0, 0, 0, 0],
    ]

    target= [0, 15]
    expect = [
      "left", "left", "down", "right"
    ]
    response = @matrix.find_path(current_post, target, original_matrix, character_matrix)
    assert_equal(response, expect, "it should be equal")
  end
end