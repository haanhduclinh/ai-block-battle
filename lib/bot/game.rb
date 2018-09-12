class Game
  attr_accessor :state, :action, :flip, :current_sign, :view

  def initialize(current_state)
    @state = current_state
    @action = Command.new
    @flip = Flip.new
    @view = View.new
  end

  def caculate_next_action
    @current_sign = @state.this_piece_type
    can_land_positions = FindPaths.new(@state.current_map, @current_sign)

    position = can_land_positions.best_choice
    # position
    # {:type=>1, :pos=>["0,2", 68]}

    target_pos = position[:pos].first.split(",").map(&:to_i)
    character_type = {
      rotate: position[:type],
      character_type: @current_sign
    }

    # binding.pry if @state.round.to_i == 19

    go = Go.new(current_pos, target_pos, character_type, @state.current_map, debug: false)
    go.now!
  end

  private
  
  def current_pos
    @state.this_piece_position.split(",").map(&:to_i)
  end
end