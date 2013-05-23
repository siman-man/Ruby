class Test

  def method_missing(name, *args)
    p name
    p args
  end

  def hello(*args)
    p "hello"
  end
end

@t = Test.new

def test(&block)
  @t.instance_eval(&block)
end

@t.test(:+, (:hello, 3))
