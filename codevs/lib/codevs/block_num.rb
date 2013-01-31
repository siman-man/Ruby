a = 150

(1..10).each do |i|
  d = 4*(i-1)/10
  case d
  when 0
    puts "#{i} block num #{4*a}"
  when 1
    puts "#{i} block num #{2*a}"
  when 2
    puts "#{i} block num #{1*a}"
  when 3
    puts "#{i} block num #{1*a}"
  end
end

puts ""
a = 80

(1..20).each do |i|
  d = 4*(i-1)/20
  case d
  when 0
    puts "#{i} block num #{4*a}"
  when 1
    puts "#{i} block num #{2*a}"
  when 2
    puts "#{i} block num #{1*a}"
  when 3
    puts "#{i} block num #{1*a}"
  end
end

puts ""
a = 90
(1..30).each do |i|
  d = 4*(i-1)/30
  case d
  when 0
    puts "#{i} block num #{4*a}"
  when 1
    puts "#{i} block num #{2*a}"
  when 2
    puts "#{i} block num #{1*a}"
  when 3
    puts "#{i} block num #{1*a}"
  end
end
