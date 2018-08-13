class GameMatrix
  def matrix_after_land(original_matrix, character_matrix, land_pos)
    # while character_matrix[character_matrix.size - 1].all? {|x| x.zero? }
    #   character_matrix = move_to_bottom(character_matrix)
    # end

    matrix_size = [character_matrix.first.size, character_matrix.size]

    # while character_matrix.all? {|x| x[0].zero? }
    #   character_matrix = move_to_left(character_matrix)
    # end

    # while character_matrix.all? {|x| x[character_matrix.first.size - 1].zero? }
    #   character_matrix = move_to_right(character_matrix)
    # end

    small_original_matrix = Matrix[*build_matrix_from_start_point(original_matrix, land_pos, matrix_size)]
    character_matrix = Matrix[*(character_matrix)]

    combine_matrix = (small_original_matrix + character_matrix).to_a
    merge_array(original_matrix, combine_matrix, land_pos)
  end

  def move_to_bottom(character_matrix)
    arr = Array.new(character_matrix.size) { Array.new(character_matrix.size) }

    max_width_character_matrix = character_matrix.first.size - 1
    max_height_character_matrix = character_matrix.size - 1

    (0..max_width_character_matrix).each {|x| arr[0][x] = 0 }

    (0..max_height_character_matrix).each do |y|
      (0..max_width_character_matrix).each do |x|
        next if y.zero?
        arr[y][x] = character_matrix[y - 1][x]
      end
    end

    arr
  end

  def move_to_left(character_matrix)
    arr = Array.new(character_matrix.size) { Array.new(character_matrix.size) }

    max_width_character_matrix = character_matrix.first.size - 1
    max_height_character_matrix = character_matrix.size - 1

    arr.each {|x| x[max_width_character_matrix] = 0 }

    (0..max_height_character_matrix).each do |y|
      (0..max_width_character_matrix).each do |x|
        next if x == max_width_character_matrix
        arr[y][x] = character_matrix[y][x + 1]
      end
    end

    arr
  end

  def move_to_right(character_matrix)
    arr = Array.new(character_matrix.size) { Array.new(character_matrix.size) }

    max_width_character_matrix = character_matrix.first.size - 1
    max_height_character_matrix = character_matrix.size - 1

    arr.each {|x| x[0] = 0 }

    (0..max_height_character_matrix).each do |y|
      (0..max_width_character_matrix).each do |x|
        next if x.zero?

        arr[y][x] = character_matrix[y][x - 1]
      end
    end

    arr
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
    max_origin_width = original_matrix.first.size
    max_origin_height = original_matrix.size

    (0..max_origin_height).each do |y|
      (0..max_origin_width).each do |x|
        check_x = max_origin_width - x - size_x
        check_y = max_origin_height - y - size_y
          next if max_origin_height[check_x][check_y].zero? && !(check_y..0).all? {|col| original_matrix[col][check_x].zero? }
          result << [check_x, check_y] if check_x >= 0 && check_y >= 0
      end
    end

    result
  end

  def bonus_to_get_score(original_matrix, character_matrix, check)
    score = 0
    map_for_caculate = matrix_after_land(original_matrix, character_matrix, check)
    map_for_caculate.each do |rows|
      score += GET_SCORE if rows.all? {|c| !c.zero? }
    end

    score
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

  def landable_pos(original_matrix, character_matrix, character_type)
    # character_type = {
    #   rotate: NORMAL_TYPE,
    #   character_type: sign
    # }

    character_matrix = normalize_character(character_type) || character_matrix

    size_x = character_matrix.first.size
    size_y = character_matrix.size

    matrix_size = [character_matrix.first.size, character_matrix.size]

    checks = divide_to_start_point(original_matrix, size_x, size_y)
    results = {}

    checks.each do |check|

      update_correct_y = check

      smaller_matrix = Matrix[*build_matrix_from_start_point(original_matrix, update_correct_y, matrix_size)]
      new_matrix = Matrix[*character_matrix] + normalize_matrix(smaller_matrix.to_a)

      results[check.join(",")] = caculate_score(original_matrix, character_matrix, update_correct_y) + bonus_to_get_score(original_matrix, character_matrix, update_correct_y) if valid_matrix?(new_matrix)
    end

    binding.pry if ENV['DEBUG']
    choose_best(results.sort_by(&:last).last(10), original_matrix, character_matrix)
  end

  def normalize_character(character_type)
    case character_type[:character_type]
    when O
      O_MATRIX
    when I
      chose_i(character_type[:rotate])
    when J
      chose_j(character_type[:rotate])
    when L
      chose_l(character_type[:rotate])
    when S
      chose_s(character_type[:rotate])
    when T
      chose_t(character_type[:rotate])
    when Z
      chose_z(character_type[:rotate])
    end
  end

  def chose_i(rotate)
    case rotate
    when NORMAL_TYPE || FLIP_180_TYPE
      [
        [1, 1, 1, 1]
      ]
    when FLIP_90_TYPE || FLIP_270_TYPE
      [
        [1],
        [1],
        [1],
        [1]
      ]
    end
  end

  def chose_j(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [1, 0, 0],
        [1, 1, 1],
      ]
    when FLIP_90_TYPE
      [
        [1, 1],
        [1, 0],
        [1, 0]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [0, 0, 1],
      ]
    when FLIP_270_TYPE
      [
        [0, 1],
        [0, 1],
        [1, 1]
      ]
    end
  end

  def chose_l(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [0, 0, 1],
        [1, 1, 1]
      ]
    when FLIP_90_TYPE
      [
        [1, 0],
        [1, 0],
        [1, 1]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [1, 0, 0],
      ]
    when FLIP_270_TYPE
      [
        [1, 1],
        [0, 1],
        [0, 1]
      ]
    end
  end

  def chose_s(rotate)
    case rotate
    when NORMAL_TYPE || FLIP_180_TYPE
      [
        [0, 1, 1],
        [1, 1, 0]
      ]
    when FLIP_90_TYPE || FLIP_270_TYPE
      [
        [1, 0],
        [1, 1],
        [0, 1]
      ]
    end
  end

  def chose_t(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [0, 1, 0],
        [1, 1, 1],
      ]
    when FLIP_90_TYPE
      [
        [1, 0],
        [1, 1],
        [1, 0]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [0, 1, 0],
      ]
    when FLIP_270_TYPE
      [
        [0, 1],
        [1, 1],
        [0, 1]
      ]
    end
  end
 
  def chose_z(rotate)
    case rotate
    when NORMAL_TYPE || FLIP_180_TYPE
      [
        [1, 1, 0],
        [0, 1, 1],
      ]
    when FLIP_90_TYPE || FLIP_270_TYPE
      [
        [0, 1],
        [1, 1],
        [1, 0]
      ]
    end
  end

  def choose_best(results, original_matrix, character_matrix)
    new_results = Array.new(results.size) { Array.new(results.first.size) }

    results.each_with_index do |check, index|
      land_pos = check.first.split(",").map(&:to_i)

      original_dead_hole = find_dead_hole(original_matrix)
      this_map = matrix_after_land(original_matrix, character_matrix, land_pos)
      dead_hole_with_check = find_dead_hole(this_map)

      if dead_hole_with_check <= original_dead_hole
        pos = results[index].first
        new_score = results[index].last - (original_dead_hole - dead_hole_with_check) * DEAD_HOLE_SCORE
        new_results[index] = [pos, new_score]
      end
    end

    new_results.select {|x| !x.first.nil? }.sort_by(&:last).last
  end

  def find_dead_hole(original_matrix)
    matrix = build_matrix_without_start_character(original_matrix)

    max_matrix_height = matrix.size - 1
    max_matrix_width = matrix.first.size - 1
    dead_hole = []

    (0..max_matrix_height).each do |y|
      (0..max_matrix_width).each do |x|
        check_point = matrix[y][x]

        if angle?(x, y, matrix)
          dead_hole << [x, y] if matrix[y][x].zero? && valid_dead_hole_in_angle?(x, y, matrix)
        elsif near_boder?(x, y, matrix)
          dead_hole << [x, y] if matrix[y][x].zero? && valid_near_boder?(x, y, matrix)
        elsif matrix[y][x].zero? && special_move_deadhole?(x, y, matrix) && !((0..y).all? {|check_y| matrix[check_y][x].zero? })
          dead_hole << [x, y]
        elsif matrix[y][x].zero? && !((0..y).all? {|check_y| matrix[check_y][x].zero? })
          dead_hole << [x, y]
        else
          dead_hole << [x, y] if matrix[y][x].zero? && !((0..y).all? {|check_y| matrix[check_y][x].zero? }) && valid_normal_deadhole?(x, y, matrix)
        end
      end
    end

    dead_hole.size
  end

  def build_matrix_without_start_character(matrix)
    arr = Array.new(matrix.size) { Array.new(matrix.first.size) }

    arr[0] = Array.new(matrix.first.size) { 0 }

    max_height = matrix.size - 1
    max_width = matrix.first.size - 1
    (1..max_height).each do |new_y|
      (0..max_width).each do |new_x|
        arr[new_y][new_x] = matrix[new_y][new_x]
      end
    end

    arr
  end

  def special_move_deadhole?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    max_y_check = y - 1

    !((0..max_y_check).all? {|check_y| matrix[check_y][x].zero? })
  end

  def valid_normal_deadhole?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    !matrix[y][x + 1].zero? && !matrix[y][x - 1].zero? && !matrix[y - 1][x].zero? && !matrix[y + 1][x].zero?
  end

  def valid_near_boder?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    case
    when y == 0
      !matrix[0][x + 1].zero? && !matrix[0][x - 1].zero? && !matrix[1][x].zero?
    when x == 0
      !matrix[y-1][0].zero? && !matrix[y + 1][0].zero? && !matrix[y][1].zero?
    when y == max_height && !((0..y).all? {|check_y| matrix[check_y][x].zero? })
      !matrix[max_height - 1][x].zero?
    when x == max_with
      !matrix[y][max_with - 1].zero?
    end
  end

  def near_boder?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    x == 0 || y == 0 || x == max_with || y == max_height
  end

  def valid_dead_hole_in_angle?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    case
    when x == 0 && y == 0
      !matrix[0][1].zero? && !matrix[1][0].zero?
    when x == 0 && y == max_height
      !matrix[max_height - 1][0].zero? && !matrix[max_height][1].zero?
    when x == max_with && y == 0
      !matrix[0][max_with - 1].zero? && !matrix[1][max_with].zero?
    when x == max_with && y == max_height
      !matrix[max_height][max_with - 1].zero? && !matrix[max_height - 1][max_with].zero?
    end
  end

  def angle?(x, y, matrix)
    max_with = matrix.first.size - 1
    max_height = matrix.size - 1

    (x == 0 && y == 0) ||
    (x == 0 && y == max_height) ||
    (x == max_with && y == 0) ||
    (x == max_with && y == max_height)
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














