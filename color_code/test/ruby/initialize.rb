class Hello
  def initialize(name, message)
    @name = name
    @message = message
  end

  def say_message
    puts "#{@name} say #{@message}"
  end
end

siman = Hello.new('siman', 'Hello Ruby!')
simanman = Hello.new('simanman', 'Hello World!')

siman.say_message
simanman.say_message
