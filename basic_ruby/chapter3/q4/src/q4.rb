# encoding: utf-8
class Q4
    def dice_roll()
        return (rand(6)+1).ceil
    end
end

q = Q4.new
sum = 0
3.times do |i|
    value = q.dice_roll()
    puts "#{i+1}回目の出目は#{value}です。"
    sum += value
end
puts "3回サイコロを振った合計値は#{sum}です。"
