def factorial(num)
  return 1 if num == 0
  num * factorial(num-1)
end

puts "3! = #{factorial(3)}"
puts "5! = #{factorial(5)}"
