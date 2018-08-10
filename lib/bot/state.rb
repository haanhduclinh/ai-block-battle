class State
  attr_accessor :round, :this_piece_type, :next_piece_type, :this_piece_position
  attr_accessor :players
  attr_accessor :settings

  def my_player
    player(settings.your_bot)
  end

  def convert_to_matrix(display_view = true)
    display_array = display_view ? my_player.field.reverse : my_player.field
    display_array.map {|rows| rows.map(&:to_i) }
  end

  def current_score(display_view = false)
    score = 0
    convert_to_matrix(display_view).each_with_index do |row, index|
      score += index * (row.reduce(&:+))
    end

    score
  end

  def player(player_id)
    players.detect { |player| player.id == player_id }
  end
end
