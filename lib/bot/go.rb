class Go
  include GameMatrix
  attr_accessor :current_pos, :target_pos, :character_type, :original_matrix, :debug

  def initialize(current_pos, target_pos, character_type, original_matrix, debug: false)
    @current_pos = current_pos
    @target_pos = target_pos
    @character_type = character_type
    @view = View.new
    @original_matrix = original_matrix
    @debug = debug
  end

  def now!
    commands = []

    binding.pry if @debug

    case @character_type[:rotate]
    when NORMAL_TYPE
      commands += go_to
    when FLIP_90_TYPE
      commands << "turnright"

      update_current_pos!
      commands += go_to
    when FLIP_180_TYPE
      commands << "turnright"
      commands << "turnright"

      update_current_pos!
      commands += go_to
    when FLIP_270_TYPE
      commands << "turnleft"

      update_current_pos!
      commands += go_to
    end

    puts commands.join(",")
  end

  def go_to
    # {:type=>1, :pos=>["[0, 2]", 68]}
    # NORMAL_TYPE = 0
    # FLIP_90_TYPE = 1
    # FLIP_180_TYPE = 2
    # FLIP_270_TYPE = 3

    binding.pry if debug?

    if need_special_move?
      special_move
    else
      goto_normal
    end
  end

  def goto_normal
    current_pos_x, current_pos_y = @current_pos
    target_x, target_y = @target_pos

    commands = []

    field_height = @original_matrix.size - 1
    field_width = @original_matrix.first.size - 1

    while target_x > current_pos_x && current_pos_x + character_matrix.first.size <= field_width do
      commands << RIGHT
      current_pos_x += 1
    end

    while target_x < current_pos_x && current_pos_x >= 0 do
      commands << LEFT
      current_pos_x -= 1
    end

    commands << DROP

    # while target_y > current_pos_y && current_pos_y + character_matrix.size <= field_height do
    #   commands << DOWN
    #   current_pos_y += 1
    # end

    commands
  end

  def need_special_move?
    return false
    # land_pos = pos[:pos].first.split(",")
    # target_x, target_y = land_pos

    # target_point = @state.current_map[target_x, target_y]

    # map_after_land = @view.matrix_after_land(@settings.current_map, character_matrix, land_pos)
    # character_matrix = character_matrix
  end

  def special_move
  end

  def update_current_pos!
    current_x, current_y = @current_pos
    target_x, target_y = @target_pos

    case
    when @character_type[:character_type] == T && @character_type[:rotate] == FLIP_90_TYPE
      current_x += 1
    when @character_type[:character_type] == Z && @character_type[:rotate] == FLIP_90_TYPE
      current_x += 1
    when @character_type[:character_type] == J && @character_type[:rotate] == FLIP_90_TYPE
      current_x += 1
    when @character_type[:character_type] == L && @character_type[:rotate] == FLIP_90_TYPE
      current_x += 1
    when @character_type[:character_type] == I && @character_type[:rotate] == FLIP_90_TYPE
      current_x += 2
    when @character_type[:character_type] == I && @character_type[:rotate] == FLIP_270_TYPE
      current_x += 1
    end

    @current_pos = [current_x, current_y]
  end

  private


  def character_matrix
    normalize_character(@character_type) || original_character(@character_type[:character_type])
  end
end