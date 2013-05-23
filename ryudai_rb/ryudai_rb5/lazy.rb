fizzbuzz = Enumerator.new{|yielder|
  1.upto(Float::INFINITY) do |n|
    case 
    when n % 15 == 0 then yielder << "FizzBuzz"
    when n % 5 == 0 then yielder << "Buzz"
    when n % 3 == 0 then yielder << "Fizz"
    else yielder << n.to_s
    end
  end
}

fizzbuzz.first(100).each do |str|
  puts str
end
