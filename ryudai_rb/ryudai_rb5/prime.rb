class Siman
  attr_reader :nums

  def initialize
    @nums = (1..Float::INFINITY).lazy.select do |num|
      num if num % 2 != 0 && num % 3 != 0
    end
  end

  def take(count)
    @nums.take(count).to_a
  end
end

s = Siman.new
p s.take(100)
