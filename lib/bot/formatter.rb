class Formatter
  def self.format_input(input_line)
    input_line.tr!(',', ' ') if input_line.include?('player_names')
    input_line.delete!(',') if input_line.include?('game field')
    input_line.split(' ')
  end
end
