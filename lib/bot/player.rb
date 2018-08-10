class Player
  attr_accessor :id, :row_points, :combo, :skips
  attr_accessor :field

  def initialize(id)
    @id = id
  end

  def field=(raw_field)
    @field = raw_field.reverse.split(";").map { |a| a.split(",") }.map {|a| a.map(&:to_i) }
  end
end
