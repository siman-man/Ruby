class Hello
  attr_accessor :message

  def initialize
    @message = 'Hello Ruby!'
  end
end

h = Hello.new
puts h.message

h.message = 'Hello World!'
puts h.message
