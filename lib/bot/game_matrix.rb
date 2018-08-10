class GameMatrix
  def matrix_after_land(original_matrix, character_matrix, land_pos)
    matrix_size = [character_matrix.first.size, character_matrix.size]
    small_original_matrix = Matrix[*build_matrix_from_start_point(original_matrix, land_pos, matrix_size)]
    character_matrix = Matrix[*character_matrix]

    combine_matrix = (small_original_matrix + character_matrix).to_a
    merge_array(original_matrix, combine_matrix, land_pos)
  end

  def merge_array(original_matrix, with_array, land_pos)
    result = Array.new(original_matrix.size) { Array.new(original_matrix.first.size) }

    max_size_y = result.size - 1
    max_size_x = result.first.size - 1

    (0..max_size_y).each do |y|
      (0..max_size_x).each do |x|
        result[y][x] = original_matrix[y][x]
      end
    end

    start_point_x, start_point_y = land_pos

    max_new_arr_x = with_array.first.size - 1
    max_new_arr_y = with_array.size - 1

    (0..max_new_arr_y).each do |y|
      (0..max_new_arr_x).each do |x|
        result[x + start_point_x][start_point_y + y] = with_array[x][y]
      end
    end

    result
  end

  def divide_to_start_point(original_matrix, size_x, size_y)
    # example separate 4x4 -> 2x2 -> It will return start poin of smaller matrix

    result = []
    start_point_x = 0
    start_point_y = 0

    max_origin_width = original_matrix.first.size - 1
    max_origin_height = original_matrix.size - 1
    (start_point_x..max_origin_width).each do |x|
      (start_point_y..max_origin_height).each do |y|
        next unless original_matrix[x + size_x][y + size_y]

        result << [x, y]
      end
    end

    result
  end

  def landable_pos(original_matrix, character_matrix)
    size_x = character_matrix.first.size
    size_y = character_matrix.size
    matrix_size = [character_matrix.first.size, character_matrix.size]

    checks = divide_to_start_point(original_matrix, size_x, size_y)
    results = {}

    debug = 0

    checks.each do |check|
      smaller_matrix = Matrix[*build_matrix_from_start_point(original_matrix, check, matrix_size)]
      new_matrix = Matrix[*character_matrix] + smaller_matrix

      results[check.join(",")] = caculate_score(original_matrix, character_matrix, check) if valid_matrix?(new_matrix)
    end

    results.sort_by(&:last).first
  end

  def caculate_score(original_matrix, character_matrix, land_pos)
    map_for_caculate = matrix_after_land(original_matrix, character_matrix, land_pos)
    caculate_score_on_map(map_for_caculate)
  end

  def build_matrix_from_start_point(original_matrix, start_point, matrix_size)
    # example start point [0,1] and matrix_size [2,3]

    start_point_x, start_point_y = start_point
    matrix_size_x, matrix_size_y = matrix_size

    matrix_size_x_limit = matrix_size_x - 1
    matrix_size_y_limit = matrix_size_y - 1

    result = []

    (0..matrix_size_y_limit).each do |y|
      row = []
      (0..matrix_size_x_limit).each do |new_x|
        row << original_matrix[start_point_x + new_x][start_point_y + y]
      end

      result << row
    end

    result
  end

  def valid_matrix?(matrix)
    # can not have sum more than 2
    response = matrix.index do |e|
                e > 2
              end

    !response
  end

  def caculate_score_on_map(map_for_caculate)
    score = 0
    map_for_caculate.each_with_index do |row, index|
      score += (index + 1) * (row.reduce(&:+))
    end

    score
  end
end














