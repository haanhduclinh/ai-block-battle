class Game
  attr_accessor :state, :action

  def initialize(current_state)
    @state = current_state
    @action = Command.new
  end

  def caculate_next_action
    case @state.this_piece_type
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
end