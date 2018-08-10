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
      pos = find_land(@current_character)
      do_action(pos, I)
    when J
      @current_character = J_MATRIX
      pos = find_land(@current_character)
      do_action(pos, J)
    when L
      @current_character = L_MATRIX
      pos = find_land(@current_character)
      do_action(pos, L)
    when O
      @current_character = O_MATRIX
      pos = find_land(@current_character)
      do_action(pos, O)
    when S
      @current_character = S_MATRIX
      pos = find_land(@current_character)
      do_action(pos, S)
    when T
      @current_character = T_MATRIX
      pos = find_land(@current_character)
      do_action(pos, T)
    when Z
      @current_character = Z_MATRIX
      pos = find_land(@current_character)
      do_action(pos, Z)
    end
  end

  def go_to(x, y, special = false)
    # special ability to turnleft or turn right at last line
    commands = []
    current_pos_x, current_pos_y = @state.this_piece_position.split(",").map(&:to_i)

    field_height = @state.settings.field_height.to_i - 1
    field_width = @state.settings.field_width.to_i - 1

    while x > current_pos_x && current_pos_x + @current_character.size <= field_width do
      commands << RIGHT
      current_pos_x += 1
    end

    while x < current_pos_x && current_pos_x - @current_character.size >= 0 do
      commands << LEFT
      current_pos_x -= 1
    end

    while y > current_pos_y && current_pos_y - @current_character.size <= field_height do
      commands << DOWN
      current_pos_y += 1
    end

    commands
  end

  def find_land(character_matrix)
    result = {}
    possible_pos = find_suitable_pos
  binding.pry
    possible_pos.sort_by {|x| x[:pos].last }.first
  end

  def do_action(pos, character)
    # {:type=>1, :pos=>["[0, 2]", 68]}
    commands = []
    binding.pry
    target_x, target_y = x_y_caculate_to_realmap(pos[:pos].first.split(",").map(&:to_i))

    case pos[:type]
    when NORMAL_TYPE
      commands += go_to(target_x, target_y)
    when FLIP_90_TYPE
      commands << "turnright"
      commands += go_to(target_x, target_y)
    when FLIP_180_TYPE
      commands << "turnright"
      commands << "turnright"
      commands += go_to(target_x, target_y)
    when FLIP_270_TYPE
      commands << "turnleft"
      commands += go_to(target_x, target_y)
    end

    puts commands.join(",")
  end

  def x_y_caculate_to_realmap(x_y_caculate_map)
    caculate_y, caculate_x = x_y_caculate_map

    field_height = @state.settings.field_height.to_i - 1
    field_width = @state.settings.field_width.to_i - 1

    [field_width - caculate_x, field_height - caculate_y]
  end

  def find_suitable_pos
    result = []

    result << {
      type: NORMAL_TYPE,
      pos: @game_matrix.landable_pos(@state.current_map, @current_character)
    }

    character_90 = @flip.rotate_90(@current_character)
    result << {
      type: FLIP_90_TYPE,
      pos: @game_matrix.landable_pos(@state.current_map, character_90)
    }

    character_180 = @flip.rotate_180(@current_character)
    result << {
      type: FLIP_180_TYPE,
      pos: @game_matrix.landable_pos(@state.current_map, character_180)
    }

    character_270 = @flip.rotate_180(@current_character)
    result << {
      type: FLIP_270_TYPE,
      pos: @game_matrix.landable_pos(@state.current_map, character_180)
    }

    result
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

  def combine_map(character, map, input_pos)
    x, y = input_pos
    map[x][y] = 1
    map
  end
end