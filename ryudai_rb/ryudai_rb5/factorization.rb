require 'prime'

class Integer
  # 素数指数表現
  def prime_decomposition
    result = Hash.new(0)
    primes = Prime.each(Float::INFINITY).lazy
    num = self

    div = 1

    while num / div != 0
      div = primes.next
      count = 0
      while num % div == 0
        num /= div
        count += 1
      end
      result[div] = count unless count.zero?
    end

    result
  end
end

class Array
  def lcm
    self.inject{|a,b| a.lcm(b)}
  end

  def gcd
    self.inject{|a,b| a.gcd(b)}
  end
end
