class Object
  def true?
    (self && true).!.!
  end

  def false?
    !(self || false)
  end
end

puts "----------------------------------"

puts "true.true? => #{true.true?}"
puts "false.true? => #{false.true?}"
puts "nil.true? => #{nil.true?}"
puts "3.true? => #{3.true?}"
puts "'true'.true? => #{'true'.true?}"
puts "[].true? => #{[].true?}"

puts "----------------------------------"

puts "true.false? => #{true.false?}"
puts "false.false? => #{false.false?}"
puts "nil.false? => #{nil.false?}"
puts "3.false? => #{3.false?}"
puts "'false'.false? => #{'false'.false?}"
puts "[].false? => #{[].false?}"

puts "----------------------------------"
