class Array
  def [] *args
    p args
  end

  def parse(list)
    list.map do |elem|
      if elem.class == Array
      else
        elem
      end
    end
  end
end

lisp = []

lisp [:+, 1, 2]
lisp [:+, [:+, 1, 2], [:+, 3, 4]]
