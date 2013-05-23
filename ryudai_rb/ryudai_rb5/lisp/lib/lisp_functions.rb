module LISP_FUNCTIONS
  def set(sym, val)
    p sym
    return false if sym.class != Symbol
    @variables[sym] = val 
  end

  def setq(sym, val)
    @variables[sym.to_sym] = val
  end

  def +(first,second)
    first + second
  end

  def -(first,second)
    first - second
  end

  def /(first,second)
    first / second
  end

  def *(first,second)
    first * second
  end

  def %(first,second)
    first % second
  end

  def ==(first,second)
    first == second
  end

end
