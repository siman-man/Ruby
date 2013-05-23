def fibo(num)
  a = 0
  b = 1
  (num).times do
    a, b = a + b, a
  end
  return a
end

fibo_list = []

1.upto(10) do |num|
  fibo_list << fibo(num)
end

puts fibo_list.join(' ')
