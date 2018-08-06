class Command
  ACTIONS = %w(left right down turnleft turnright).freeze

  def left
    puts :left
  end

  def right
    puts :right
  end

  def down
    puts :down
  end

  def turn_left
    puts :turnleft
  end

  def turn_right
    puts :turnright
  end

  def random
    puts ACTIONS.sample(Random.rand(1..5)).join(",")
  end
end