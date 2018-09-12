class View
  def matrix_after_land(original_matrix, character_matrix, land_pos)
    matrix_size = [character_matrix.first.size, character_matrix.size]

    small_original_matrix = Matrix[*build_matrix_from_start_point(original_matrix, land_pos, matrix_size)]
    character_matrix = Matrix[*(character_matrix)]

    combine_matrix = (small_original_matrix + character_matrix).to_a
    merge_array(original_matrix, combine_matrix, land_pos)
  end

  def build_matrix_from_start_point(original_matrix, start_point, matrix_size)
    # example start_point = [0,1] and matrix_size = [2,3]
    
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

  private

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
end