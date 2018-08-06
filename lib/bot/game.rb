class Game
  attr_accessor :state, :action

  def initialize(current_state)
    @state = current_state
    @action = Command.new
  end

  def caculate_next_action
    character_matrix = I

    case @state.this_piece_type
    when I
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when J
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when L
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when O
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when S
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when T
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    when Z
      pos = find_land(character_matrix)
      x, y = pos.first.to_s.split("_").map(&:to_i)
    end

    move_to(x, y)
  end

  def move_to(x, y)
    commands = []
    current_pos_x, current_pos_y = @state.this_piece_position.split(",").map(&:to_i)

    move_x_commands = if x > current_pos_x
                        "left"
                      else
                        "right"
                      end

    (x - current_pos_x).abs.times { commands << move_x_commands }

    commands
    puts commands.join(",")
  end

  def find_land(character_matrix)
    result = {}
    map_for_caculate = @state.convert_to_matrix(false)
    possible_pos = find_suitable_pos(map_for_caculate)
    possible_pos.each do |ability|
      key = ability.join("_")
      map_combine = combine_map(character_matrix, map_for_caculate, ability)
      result[key.to_sym] = caculate_score_on_map(map_combine)
    end
    result.sort_by(&:last).first
  end

  def caculate_score_on_map(map_for_caculate)
    score = 0
    map_for_caculate.each_with_index do |row, index|
      score += index * (row.reduce(&:+))
    end

    score
  end

  def find_suitable_pos(map_for_caculate)
    result = []
    max_height = @state.settings.field_width.to_i - 1
    max_width = @state.settings.field_height.to_i - 1

    (0..max_height).each do |x|
      (0..max_width).each do |y|
        result << [x, y] if validate?(x, y, map_for_caculate)
      end
    end

    result
  end

  def validate?(x, y, map)
    sum = 0
    sum += map[y][x]

    while y < @state.settings.field_height.to_i - 1 do
      sum += map[y][x]
      y += 1
    end

    sum.zero?
  end

  def combine_map(character, map, input_pos)
    x, y = input_pos
    map[x][y] = 1
    map
  end
end