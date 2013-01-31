(1..50).each do |c|
  s1 = 2**([c,30 + 0].min-1)
  s2 = [1,c-(30-0)+1].max * 2
  puts "#{c} chain : #{s1} #{s2} = #{s1*s2}"
end
