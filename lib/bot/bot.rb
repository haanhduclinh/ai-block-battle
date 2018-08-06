class Bot
  attr_accessor :state

  def initialize
    @state = State.new
    @state.settings = Settings.new
  end

  def run(input = '')
    $stdout.sync = true

    read_engine_messages(input) do |line|
      parse(line.chomp) unless line.chomp.empty?
    end
  end

  private

  def read_engine_messages(input)
    return unless block_given?

    if input.empty?
      # reads lines from engine
      while (line = gets)
        yield(line)
      end
    else
      input.each_line do |line|
        yield(line)
      end
    end
  end

  def parse(line)
    formatted_line = Formatter.format_input(line)
    case formatted_line.shift
    when 'action'
      game = Game.new(@state)
      game.caculate_next_action
    when 'settings'
      update_setting(formatted_line)
    when 'update'
      update_game(formatted_line)
    when 'quit'
      exit(true)
    end
  end

  def update_setting(formatted_line)
    setting_attr = formatted_line.shift
    setting_value = formatted_line.size == 1 ? formatted_line[0] : formatted_line
    @state.settings.send("#{setting_attr}=", setting_value)

    return unless setting_attr == 'player_names'
    @state.players = setting_value.map { |id| Player.new(id) }
  end

  def update_game(formatted_line)
    update_kind = formatted_line.shift
    state_attr = formatted_line.shift
    state_value = formatted_line.size == 1 ? formatted_line[0] : formatted_line

    if update_kind == 'game'
      @state.send("#{state_attr}=", state_value)
    else
      player_id = update_kind
      player = @state.player(player_id)
      player.send("#{state_attr}=", state_value)
    end
  end
end
