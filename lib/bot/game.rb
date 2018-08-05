class Game
  attr_accessor :settings, :state, :action
  def initialize(settings, current_state)
    @settings = settings
    @state = current_state
    @action = Command.new
  end

  def caculate_next_action
    case @state.current_type.first
    when I
      @action.random
    when J
      @action.random
    when L
      @action.random
    when O
      @action.random
    when S
      @action.random
    when T
      @action.random
    when Z
      @action.random
    end
  end

  def move_to(x, y)
    commands = []
    current_pos_x, current_pos_y = @state.current_type_start.split(",")

    move_x_commands = if x > current_pos_x
                        "left"
                      else
                        "right"
                      end

    (x - current_pos_x).abs.times { commands << move_x_commands }

    commands
  end
end