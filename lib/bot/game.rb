class Game
  attr_accessor :state, :action, :game_matrix, :flip

  def initialize(current_state)
    @state = current_state
    @action = Command.new
    @game_matrix = GameMatrix.new
    @flip = Flip.new
  end

  def caculate_next_action
    case @state.this_piece_type
    when I
      pos = find_land(I_MATRIX)
      do__action(pos)
    when J
      pos = find_land(J_MATRIX)
      do__action(pos)
    when L
      pos = find_land(L_MATRIX)
      do__action(pos)
    when O
      pos = find_land(O_MATRIX)
      do__action(pos)
    when S
      pos = find_land(S_MATRIX)
      do__action(pos)
    when T
      pos = find_land(T_MATRIX)
      do__action(pos)
    when Z
      pos = find_land(Z_MATRIX)
      do__action(pos)
    end
  end

  def move_to(x, y)
    commands = []
    current_pos_x, current_pos_y = @state.this_piece_position.split(",").map(&:to_i)

    move_x_commands = if x > current_pos_x
                        "right"
                      else
                        "left"
                      end

    (x - current_pos_x).abs.times { commands << move_x_commands }

    commands << "drop"
    commands
  end

  def find_land(character_matrix)
    result = {}
    map_for_caculate = @state.convert_to_matrix(false)
    possible_pos = find_suitable_pos(map_for_caculate, character_matrix)
    
    possible_pos.sort_by {|x| x[:pos].last }.first
  end

  def do__action(pos)
    # {:type=>1, :pos=>["[0, 2]", 68]}
    commands = []
    target_x, target_y = pos[:pos].first.split(",").map(&:to_i)

    case pos[:type]
    when NORMAL_TYPE
      commands += move_to(target_x, target_y)
    when FLIP_90_TYPE
      commands << "turnright"
      commands += move_to(target_x, target_y)
    when FLIP_180_TYPE
      commands << "turnright"
      commands << "turnright"
      commands += move_to(target_x, target_y)
    when FLIP_270_TYPE
      commands << "turnleft"
      commands += move_to(target_x, target_y)
    end

    puts commands.join(",")
  end

  def find_suitable_pos(map_for_caculate, character_matrix)
    result = []

    result << {
      type: NORMAL_TYPE,
      pos: @game_matrix.landable_pos(map_for_caculate, character_matrix)
    }

    character_90 = @flip.rotate_90(character_matrix)
    result << {
      type: FLIP_90_TYPE,
      pos: @game_matrix.landable_pos(map_for_caculate, character_90)
    }

    character_180 = @flip.rotate_180(character_matrix)
    result << {
      type: FLIP_180_TYPE,
      pos: @game_matrix.landable_pos(map_for_caculate, character_180)
    }

    character_270 = @flip.rotate_180(character_matrix)
    result << {
      type: FLIP_270_TYPE,
      pos: @game_matrix.landable_pos(map_for_caculate, character_180)
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