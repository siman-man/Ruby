class Integer
  def combination(k)
    self.factorial/(k.factorial*(self-k).factorial)
  end

  def permutation(k)
    self.factorial/(self-k).factorial
  end

  def factorial
    return 1 if self == 0
    (1..self).inject(:*)
  end
end


class C
  def initialize
    friends, wrong = gets.chomp.split(' ').map(&:to_i)

    answer_list = Array.new(friends+1).map{ Array.new(wrong+1) }
    answer_list[2][2] = 1

    3.upto(friends) do |n|
      2.upto(n) do |k|
        if n == k
          val = n-1
          2.step(n-1, 2) do |k2|
            combi = n.combination(k2)
            val += combi * answer_list[k2][k2]
          end
          answer_list[n][k] = val
        else
          num = n.combination(n-k)
          answer_list[n][k] = num * answer_list[k][k]
        end
      end
    end

    puts answer_list[friends][wrong]
  end
end

c = C.new
