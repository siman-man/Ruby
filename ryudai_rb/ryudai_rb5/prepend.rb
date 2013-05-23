module Swimmable
  def live_in_water?
    "no"
  end
end

module WhiteColorSiman
  def colors
    ["White"] + super
  end
end

class Mammal
  def fave_backbone?
    true
  end

  def live_in_water?
    false
  end
end

class Siman < Mammal
  prepend WhiteColorSiman

  def colors
    ["Gray"]
  end
end

s = Siman.new
p Siman.ancestors

p s.live_in_water?
puts "siman color list is #{s.colors}"
