require 'pp'

class LifeGame
  attr_reader :map

  def initialize(height, width)
    @width = width
    @height = height

    @map = Array.new(@height).map!{Array.new(@width, 0)}

    @map[10][10] = 1
    @map[11][9] = 1
    @map[11][10] = 1
    @map[12][10] = 1

    @map[10][15] = 1
    @map[11][16] = 1
    @map[11][15] = 1
    @map[12][15] = 1
  end

  def update
    tmp_map = Array.new(@height).map!{Array.new(@width, 0)}
    @map.each_with_index do |line, ypos|
      line.each_with_index do |elem, xpos|
        count = count_life(ypos,xpos) 
        if @map[ypos][xpos] == 1
          tmp_map[ypos][xpos] = alive_update(ypos,xpos,count)
        else
          tmp_map[ypos][xpos] = death_update(ypos,xpos,count)
        end
      end
    end
    @map = Marshal.load(Marshal.dump(tmp_map))
  end

  def alive_update(y,x,count)
    if count == 2 || count == 3
      1
    else
      0
    end
  end

  def death_update(y,x,count)
    if count == 3
      1
    else
      0
    end
  end

  def count_life(y,x)
    count = 0
    (y-1).upto(y+1) do |ypos|
      (x-1).upto(x+1) do |xpos|
        if 0 <= ypos && ypos < @height && 0 <= xpos && xpos < @width
          unless y == ypos && x == xpos 
            count += 1 if @map[ypos][xpos] == 1
          end
        end
      end
    end
    return count
  end
end
