class Flip
  def rotate_180(arr)
    new_x = arr.first.size - 1
    new_y = arr.size - 1
    new_arr = Array.new(arr.first.size) { Array.new(arr.size) }

    (0..new_x).each do |x|
      (0..new_y).each do |y|
        new_arr[x][y] = arr[new_x - x][new_y - y]
      end
    end

    new_arr
  end

  def rotate_90(arr)
    new_x = arr.first.size - 1
    new_y = arr.size - 1
    new_arr = Array.new(arr.first.size) { Array.new(arr.size) }

    (0..new_x).each do |x|
      (0..new_y).each do |y|
        new_arr[x][y] = arr[new_y - y][x]
      end
    end

    new_arr
  end

  def rotate_270(arr)
    new_x = arr.first.size - 1
    new_y = arr.size - 1
    new_arr = Array.new(arr.first.size) { Array.new(arr.size) }

    (0..new_x).each do |x|
      (0..new_y).each do |y|
        new_arr[x][y] = arr[y][new_x - x]
      end
    end

    new_arr
  end
end
