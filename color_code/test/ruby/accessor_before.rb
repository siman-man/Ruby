class Hello
  def initialize
    @message = 'Hello Ruby!'
  end

  def message
    @message
  end

  def message=(message)
    @message = message
  end
end

h = Hello.new
puts h.message

h.message = 'Hello World!'
puts h.message
