class State
  attr_accessor :round, :this_piece_type, :next_piece_type, :this_piece_position
  attr_accessor :players
  attr_accessor :settings

  def my_player
    player(settings.your_bot)
  end

  def convert_to_matrix
    parse_map.split(";").map{ |x| x.split(",").map(&:to_i) }
  end

  def current_score
    map = parse_map
    score = 0
    convert_to_matrix.each_with_index do |row, index|
      score += index * (row.reduce(&:+))
    end

    score
  end

  def player(player_id)
    players.detect { |player| player.id == player_id }
  end
end
