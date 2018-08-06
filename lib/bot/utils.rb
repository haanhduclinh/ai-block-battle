class Array
  def len
    a = []
    self.each_with_index do |x,i|
      a << [] if i % len == 0
      a.last << x
    end
    a
  end
end

class Grid < Array
  attr_accessor :set
  def initialize(set=SAMPLE_DATA)
    @set = set
    self.replace(set/Math.sqrt(set.size))
  end

  def rotate(n=1)
    (n%4).times {self.replace(self.reverse.transpose)}
  end

  def flip(direction=:right)
    case direction
    when :right then self.replace(self.transpose.rotate(1))
    when :left then self.replace(self.transpose.rotate(-1))
    end
  end

  def children ## returns array of new Grids(3x3), ordered from left to right
    return self.collect {|i| i/3}.transpose
               .collect {|i| i/3}.transpose
               .collect {|i| i.collect {|j| Grid.new(j.flatten.compact)}}
  end

  def sum
    Array.new(self.flatten.compact).sum
  end

  def columns
    self.transpose
  end

  def rows
    self
  end

  def inspect
    self.to_s
  end

  def to_s
    "\n" + self.collect {|i| i.inspect}.join("\n")
  end
end
