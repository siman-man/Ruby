require_relative './lisp_functions.rb'

class LISP
  include LISP_FUNCTIONS

  def initialize
    @variables = {}
  end

  def [] *args
    exec(*parse(args))
  end

  def parse(list)
    list.map do |elem|
      if elem.class == Array
        exec(*elem)
      else
        elem
      end
    end
  end

  # 再帰的にArrayを評価していく
  def exec(operation, *args)
    list = args.map do |elem|
      if elem.class == Array
        exec(*elem)
      else
        @variables[elem]||elem
      end
    end
    send(operation, *list)
  end
end
