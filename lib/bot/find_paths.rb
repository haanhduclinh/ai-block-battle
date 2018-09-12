class FindPaths
  include GameMatrix
  attr_accessor :original_matrix, :sign, :debug_round, :flip

  def initialize(original_matrix, sign, debug_round = false)
    @original_matrix = original_matrix
    @sign = sign
    @debug_round = debug_round
    @flip = Flip.new
    @view = View.new
  end

  def best_choice
    result = {}
    possible_pos = list_all_postions

    binding.pry if @debug_round
    # chose max score
    possible_pos.sort_by {|x| x[:pos].last }.last
  end

  private

  def list_all_postions
    [].tap do |result|
      result << normal_progress
      result << flip_90_progress
      result << flip_180_progress
      result << flip_270_progress
    end
  end

  def normal_progress
    character_type = {
      rotate: NORMAL_TYPE,
      character_type: @sign
    }

    character_matrix = original_character(@sign)

    {
      type: NORMAL_TYPE,
      pos: landable_pos(character_matrix, character_type)
    }
  end

  def flip_90_progress
    character_type = {
      rotate: FLIP_90_TYPE,
      character_type: @sign
    }

    character_matrix = original_character(@sign)
    character_90 = @flip.rotate_90(character_matrix)

    {
      type: FLIP_90_TYPE,
      pos: landable_pos(character_90, character_type)
    }
  end

  def flip_180_progress
    character_type = {
      rotate: FLIP_180_TYPE,
      character_type: @sign
    }

    character_matrix = original_character(@sign)
    character_180 = @flip.rotate_180(character_matrix)

    {
      type: FLIP_180_TYPE,
      pos: landable_pos(character_180, character_type)
    }
  end

  def flip_270_progress
    character_type = {
      rotate: FLIP_270_TYPE,
      character_type: @sign
    }

    character_matrix = original_character(@sign)
    character_270 = @flip.rotate_270(character_matrix)

    {
      type: FLIP_270_TYPE,
      pos: landable_pos(character_270, character_type)
    }
  end

  def landable_pos(character_matrix, character_type)
    # character_type = {
    #   rotate: NORMAL_TYPE,
    #   character_type: @sign
    # }

    character_matrix = normalize_character(character_type) || character_matrix
    size_x = character_matrix.first.size
    size_y = character_matrix.size

    checks = divide_to_start_point([size_x, size_y])
    results = {}

    checks.each do |check|
      smaller_matrix = Matrix[*@view.build_matrix_from_start_point(@original_matrix, check, [size_x, size_y])]
      new_matrix = Matrix[*character_matrix] + normalize_matrix(smaller_matrix.to_a)
      next unless valid_matrix?(new_matrix)
      results[check.join(",")] = caculate_score(@original_matrix, character_matrix, check) + bonus_to_get_score(@original_matrix, character_matrix, check)
    end

    positions = results.sort_by(&:last).last(SET_BOT_LEVEL)

    select(positions, character_matrix)
  end

  def select(positions, character_matrix)
    new_positions = Array.new(positions.size) { Array.new(positions.first.size) }

    positions.each_with_index do |check, index|
      land_pos = check.first.split(",").map(&:to_i)

      original_dead_hole = find_dead_hole(@original_matrix)
      this_map = @view.matrix_after_land(@original_matrix, character_matrix, land_pos)
      dead_hole_with_check = find_dead_hole(this_map)

      pos = positions[index].first

      if dead_hole_with_check < original_dead_hole
        new_score = positions[index].last + (dead_hole_with_check - original_dead_hole) * DEAD_HOLE_SCORE
        new_positions[index] = [pos, new_score]
      elsif dead_hole_with_check > original_dead_hole
        new_score = positions[index].last - (dead_hole_with_check - original_dead_hole) * DEAD_HOLE_SCORE
        new_positions[index] = [pos, new_score]
      else
        new_positions[index] = [pos, positions[index].last]
      end
    end

    new_positions.sort_by(&:last).last
  end

  def find_dead_hole(input_matrix)
    matrix = build_matrix_without_start_character(input_matrix)

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
      ((0..y).any? {|check_y| !matrix[check_y][x].zero? })
    when y == max_height
      ((0..y).any? {|check_y| !matrix[check_y][x].zero? })
    when x == max_with
      ((0..y).any? {|check_y| !matrix[check_y][x].zero? })
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
    map_for_caculate = @view.matrix_after_land(original_matrix, character_matrix, land_pos)
    caculate_score_on_map(map_for_caculate)
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

  def divide_to_start_point(position)
    # example separate 4x4 -> 2x2 -> It will return start poin of smaller matrix
    # todo enhance select better position
    # position = [size_x, size_y]

    results = []
    max_origin_width = @original_matrix.first.size
    max_origin_height = @original_matrix.size
    size_x, size_y = position

    (0..max_origin_height).each do |y|
      (0..max_origin_width).each do |x|
        check_x = max_origin_width - x - size_x
        check_y = max_origin_height - y - size_y

        next if check_x < 0 || check_y < 0
        next unless @original_matrix[check_y][check_x].zero?
        next if (check_y..0).any? { |col| !@original_matrix[col][check_x].zero? }
        results << [check_x, check_y]
      end
    end

    results
  end

  def bonus_to_get_score(original_matrix, character_matrix, check)
    score = 0
    map_for_caculate = @view.matrix_after_land(original_matrix, character_matrix, check)
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
end