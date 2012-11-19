module Test
  def print_hello
    puts "Hello"
  end
end

class Hello
  include Test
end

p = Hello.new
p.print_hello
