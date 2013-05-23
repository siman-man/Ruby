class A
  def initialize
    n = gets.chomp.to_i
    buy_list = []

    n.times do
      buy_list << gets.chomp.split(' ').map(&:to_i)
    end

    sum = 0
    buy_list.each do |list|
      sum += list[0] * list[1]
    end

    puts (sum*1.05).floor
  end
end

a = A.new
