require 'refinement'

module InchAvailable
  refine Numeric do
    def inch
      self * 2.54
    end
  end
end


class Siman
  using InchAvailable
  def initialize
    p 3.inch
  end
end

class Simanman
  def initialize
    p 10.inch
  end
end

s = Siman.new
ss = Simanman.new
