class State
  attr_accessor :round, :this_piece_type, :next_piece_type, :this_piece_position
  attr_accessor :players
  attr_accessor :settings

  def my_player
    player(settings.your_bot)
  end

  def current_map
    my_player.field.reverse
  end

  def current_score(display_view = false)
    score = 0
    current_map.each_with_index do |row, index|
      score += index * (row.reduce(&:+))
    end

    score
  end

  def player(player_id)
    players.detect { |player| player.id == player_id }
  end
end
