a = 10
b = 2
size = (a*b).to_s.size

puts ('+'+'-'*size)*(b+1)+"+"
print '|'+' '*size
1.upto(b) do |m|
  print "|%#{size}d" % [m]
end

puts '|'
puts ('+'+'-'*size)*(b+1)+"+"
1.upto(a) do |n|
  print "|%#{size}d" % [n]
  1.upto(b) do |m|
    print "|%#{size}d" % [n*m]
  end
  puts '|'
  puts ('+'+'-'*size)*(b+1)+"+"
end
