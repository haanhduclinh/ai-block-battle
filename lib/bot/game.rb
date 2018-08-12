class Game
  attr_accessor :state, :action, :game_matrix, :flip, :current_character

  def initialize(current_state)
    @state = current_state
    @action = Command.new
    @game_matrix = GameMatrix.new
    @flip = Flip.new
  end

  def caculate_next_action
    case @state.this_piece_type
    when I
      @current_character = I_MATRIX
      pos = find_land(@current_character, I)
      do_action(pos, I)
    when J
      @current_character = J_MATRIX
      pos = find_land(@current_character, J)
      do_action(pos, J)
    when L
      @current_character = L_MATRIX
      pos = find_land(@current_character, L)
      do_action(pos, L)
    when O
      @current_character = O_MATRIX
      pos = find_land(@current_character, O)
      do_action(pos, O)
    when S
      @current_character = S_MATRIX
      pos = find_land(@current_character, S)
      do_action(pos, S)
    when T
      @current_character = T_MATRIX
      pos = find_land(@current_character, T)
      do_action(pos, T)
    when Z
      @current_character = Z_MATRIX
      pos = find_land(@current_character, Z)
      do_action(pos, Z)
    end
  end

  def go_to(x, y, pos, character)
    # {:type=>1, :pos=>["[0, 2]", 68]}
    # NORMAL_TYPE = 0
    # FLIP_90_TYPE = 1
    # FLIP_180_TYPE = 2
    # FLIP_270_TYPE = 3

    current_pos_x, current_pos_y = @state.this_piece_position.split(",").map(&:to_i)

    if character == I && pos[:type] == FLIP_90_TYPE && current_pos_x > x
      x -= 0
    elsif character == I && pos[:type] == FLIP_90_TYPE && current_pos_x < x
      x += 1
    elsif character == I && pos[:type] == FLIP_270_TYPE && current_pos_x > x
      x -= 1
    elsif character == I && pos[:type] == FLIP_270_TYPE && current_pos_x < x
      x += 1
    elsif character == L && pos[:type] == FLIP_90_TYPE && current_pos_x > x
      x -= 1
    elsif character == J && pos[:type] == FLIP_90_TYPE && current_pos_x > x
      x -= 1
    elsif character == T && pos[:type] == FLIP_90_TYPE && current_pos_x < x
      x += 1
    elsif character == T && pos[:type] == FLIP_90_TYPE && current_pos_x > x
      x -= 1
    end

    commands = []

    field_height = @state.settings.field_height.to_i - 1
    field_width = @state.settings.field_width.to_i - 1

    while x > current_pos_x && current_pos_x + @current_character.first.size <= field_width do
      commands << RIGHT
      current_pos_x += 1
    end

    while x < current_pos_x && current_pos_x >= 0 do
      commands << LEFT
      current_pos_x -= 1
    end

    while y > current_pos_y && current_pos_y - @current_character.size <= field_height do
      commands << DOWN
      current_pos_y += 1
    end

    commands
  end

  def find_land(character_matrix, character)
    result = {}
    possible_pos = find_suitable_pos(@state.current_map, @current_character, character)

    binding.pry if ENV['DEBUG']
    possible_pos.sort_by {|x| x[:pos].last }.last
  end

  def do_action(pos, character)
    # {:type=>1, :pos=>["[0, 2]", 68]}

    commands = []
    target_x, target_y = pos[:pos].first.split(",").map(&:to_i)

    case pos[:type]
    when NORMAL_TYPE
      commands += go_to(target_x, target_y, pos, character)
    when FLIP_90_TYPE
      commands << "turnright"
      commands += go_to(target_x, target_y, pos, character)
    when FLIP_180_TYPE
      commands << "turnright"
      commands << "turnright"
      commands += go_to(target_x, target_y, pos, character)
    when FLIP_270_TYPE
      commands << "turnleft"
      commands += go_to(target_x, target_y, pos, character)
    end

    puts commands.join(",")
  end

  def find_suitable_pos(current_map, character, sign)
    result = []

    result << normal_progress(current_map, character, sign)

    result << flip_90_progress(current_map, character, sign)

    result << flip_180_progress(current_map, character, sign)

    result << flip_270_progress(current_map, character, sign)

    result

    # binding.pry
  end

  def normal_progress(current_map, character, sign)
    character_type = {
      rotate: NORMAL_TYPE,
      character_type: sign
    }

    {
      type: NORMAL_TYPE,
      pos: @game_matrix.landable_pos(current_map, character, character_type)
    }
  end

  def flip_90_progress(current_map, character, sign)
    character_type = {
      rotate: FLIP_90_TYPE,
      character_type: sign
    }

    character_90 = @flip.rotate_90(character)

    {
      type: FLIP_90_TYPE,
      pos: @game_matrix.landable_pos(current_map, character_90, character_type)
    }
  end

  def flip_180_progress(current_map, character, sign)
    character_type = {
      rotate: FLIP_180_TYPE,
      character_type: sign
    }

    character_180 = @flip.rotate_180(character)

    {
      type: FLIP_180_TYPE,
      pos: @game_matrix.landable_pos(current_map, character_180, character_type)
    }
  end

  def flip_270_progress(current_map, character, sign)
    character_type = {
      rotate: FLIP_270_TYPE,
      character_type: sign
    }

    character_270 = @flip.rotate_270(character)

    {
      type: FLIP_270_TYPE,
      pos: @game_matrix.landable_pos(current_map, character_270, character_type)
    }
  end

  def validate?(x, y, map)
    sum = 0
    sum += map[x][y]

    while x < @state.settings.field_height.to_i - 1 do
      sum += map[x][y]
      x += 1
    end

    sum.zero?
  end

  def find_path(current_pos, target_pos, original_matrix, character_matrix)

  end

  def combine_map(character, map, input_pos)
    x, y = input_pos
    map[x][y] = 1
    map
  end

  def check_empty_arr?(array)
    flag = 0
    check_status = true
    array.each do |val|
      if val != 0
        flag += 1
      end
    end

    if flag != 0
      check_status = false
    end

    check_status
  end

  def check_size_char?(row, character)
    return if row.first == nil?
    row.uniq.size == character.first.size
  end
end