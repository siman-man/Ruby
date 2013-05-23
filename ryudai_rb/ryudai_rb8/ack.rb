class Ack
  def initialize
    m, n = $stdin.gets.chomp.split(' ').map(&:to_i)
    puts ack(m, n)
  end

  def ack(m, n)
    if m == 0
      return n+1
    elsif n == 0
      ack(m-1, 1)
    else
      ack(m-1,ack(m, n-1))
    end
  end
end

a = Ack.new
