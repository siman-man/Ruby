class Array
  def lcm
    self.inject{|a,b| a.lcm(b)}
  end

  def gcd
    self.inject{|a,b| a.gcd(b)}
  end
end

p [1,2,3].lcm
p [1,2,3,4,5].lcm
p [4,8,16].gcd
p [100,200,300].gcd
