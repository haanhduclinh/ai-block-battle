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
        result[y + start_point_y][start_point_x + x] = with_array[y][x]
      end
    end

    result
  end

  def divide_to_start_point(original_matrix, size_x, size_y)
    # example separate 4x4 -> 2x2 -> It will return start poin of smaller matrix
    # todo enhance select better position
    result = []
    start_point_x = 0
    start_point_y = 0
    max_origin_width = original_matrix.first.size - 1
    max_origin_height = original_matrix.size - 1

    (start_point_y..max_origin_height).each do |y|
      (start_point_x..max_origin_width).each do |x|
        check_x = max_origin_width - x
        check_y = max_origin_height - y

        if check_x + size_x <= max_origin_width
          if check_y + size_y <= max_origin_height
            result << [check_x, check_y]
          end
        end
      end
    end

    result
  end

  def bonus(original_matrix, character_matrix, check)
    current_matrix_score = caculate_bonus_score(original_matrix)

    map_for_caculate = matrix_after_land(original_matrix, character_matrix, check)
    new_matrix_score = caculate_bonus_score(map_for_caculate)
    near_border_score = ((original_matrix.first.size / 2) - check.first + character_matrix.size).abs * BORDER_SCORE

    (new_matrix_score - current_matrix_score) * SCORE_BONUS + near_border_score
  end

  def caculate_bonus_score(original_matrix)
    score = 0
    max_y_index = original_matrix.size - 1
    max_x_index = original_matrix.first.size - 1

    (0..max_y_index).each do |y|
      (0..max_x_index).each do |x|
        next if x + 1 > max_x_index
        next if y + 1 > max_y_index
        next if y - 1 < 0
        next if x - 1 < 0

        if original_matrix[y][x] == 1 && original_matrix[x + 1] == 1 && original_matrix[y + 1][x] == 1 && original_matrix[y - 1][x] == 1 && original_matrix[y][x - 1] == 1
          score += 4
        elsif original_matrix[y][x] == 1 && original_matrix[x + 1] == 1 && original_matrix[y + 1][x] == 1
          score += 3
        elsif original_matrix[y][x] == 1 && original_matrix[x + 1] == 1
          score += 2
        end
      end
    end

    score
  end

  def landable_pos(original_matrix, character_matrix)
    size_x = character_matrix.first.size
    size_y = character_matrix.size

    matrix_size = [character_matrix.first.size, character_matrix.size]

    checks = divide_to_start_point(original_matrix, size_x, size_y)
    results = {}

    checks.each do |check|
      smaller_matrix = Matrix[*build_matrix_from_start_point(original_matrix, check, matrix_size)]
      new_matrix = Matrix[*character_matrix] + normalize_matrix(smaller_matrix.to_a)

      results[check.join(",")] = caculate_score(original_matrix, character_matrix, check) + bonus(original_matrix, character_matrix, check) if valid_matrix?(new_matrix)
    end

    results.sort_by(&:last).last
  end

  def normalize_matrix(matrix)
    arr = Array.new(matrix.size) { Array.new(matrix.first.size) }

    max_height = matrix.size - 1
    max_width = matrix.first.size - 1

    (0..max_height).each do |y|
      (0..max_width).each do |x|
        arr[y][x] = if matrix[y][x].zero?
                      0
                    else
                      1
                    end
      end
    end

    Matrix[*arr]
  end

  def caculate_score(original_matrix, character_matrix, land_pos)
    map_for_caculate = matrix_after_land(original_matrix, character_matrix, land_pos)
    caculate_score_on_map(map_for_caculate)
  end

  def build_matrix_from_start_point(original_matrix, start_point, matrix_size)
    # example start point [0,1] and matrix_size [2,3]

    result = Array.new(matrix_size.last) { Array.new(matrix_size.first)  }

    start_point_x, start_point_y = start_point
    matrix_size_x, matrix_size_y = matrix_size

    matrix_size_x_limit = matrix_size_x - 1
    matrix_size_y_limit = matrix_size_y - 1

    (0..matrix_size_y_limit).each do |y|
      (0..matrix_size_x_limit).each do |x|
        result[y][x] = original_matrix[start_point_y + y][start_point_x + x]
      end
    end

    result
  end

  def find_path(current_post, target, original_matrix, character_matrix)
  end

  def valid_matrix?(matrix)
    # can not have sum more than 2
    response = matrix.index do |e|
                e > 1
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














