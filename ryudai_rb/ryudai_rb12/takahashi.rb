class B
  def initialize
    @index_list = gets.chomp.split(' ')

    n = gets.chomp.to_i
    num_list = []

    n.times do 
      num_list << gets.chomp
    end

    answer = num_list.sort_by{|num| num.size}.group_by{|num| num.size}

    result = answer.map do |ans|
      ans[1].sort_by do |item|
        convert(item)
      end
    end
    result.flatten.each do |res|
      puts res
    end
  end

  def convert(num)
    num.split('').map{|elem| @index_list.find_index(elem)}
  end
end

b = B.new
