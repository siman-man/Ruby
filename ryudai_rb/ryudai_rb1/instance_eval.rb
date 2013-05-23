class Siman
  def initialize(name)
    @name = name
  end
  private
  def hello
    puts "hello #{@name}"
  end
end

siman = Siman.new("Siman")

siman.instance_eval{ hello }

siman.instance_eval { 
  def say
    puts "Siman say 'Hello Ryudai.rb'"
  end

  def my
    puts "My class is #{self.class}"
  end
}
siman.say
siman.my
