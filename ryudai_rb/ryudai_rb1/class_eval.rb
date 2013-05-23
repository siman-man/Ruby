class Siman
end

1.upto(10) do |i|
  Siman.class_eval { 
    attr_accessor :"var#{i}" 

    def hello
      puts "Hello Siman"
    end
  }
end

siman = Siman.new
siman.var4 = "test"
puts siman.var4
siman.hello
