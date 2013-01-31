#!/Users/siman/.rbenv/shims/ruby

class Stair < Puzzle
  attr_accessor :stairs, :stair_line

  def initialize
    @puzzle = Puzzle.new
    @puzzle.init_stage

    @stairs = Array.new(@puzzle.width/2).map!{ Array.new(5).map! { Array.new(11, true) } }
    @stair_line = 0
    @block_line = [@puzzle.height-6]
  end

  def stair_flag_checker(ypos, xpos, num)
    return @stairs[ypos][xpos][num-1]
  end

  def stair_flag_setter(ypos, xpos, num, flag)
    @stairs[ypos][xpos][num-1] = flag
  end

  def check_stair_move_range(pack, width)                                                                  
    size = pack.size                                                                                 
    min = size - 1                                                                                   
    max = 0
    pack.each do |line|
      line.each_with_index do |elem, index|                                                          
        if elem.to_i != 0
          min = index if min > index                                                                 
          max = index if max < index                                                                 
        end                                                                                          
      end                                                                                            
    end
    return [-min, @stairs.size+size-max-2]                                                                       
  end            

  def un_block_cheker(puzzle)
    (@puzzle.width/2).times do |xpos|
      @block_line.each do |num|
        value = puzzle.game_stage[num][xpos]
        return false if value != 0 && value != 11
      end
    end
    return true
  end

  def stair_fall(puzzle, pack)
    range = check_stair_move_range(pack, @stairs.size)
    tmp_under_line = puzzle.under_line.dup
    tmp_stage = Marshal.load(Marshal.dump(puzzle.game_stage))

    range[0].upto(range[1]) do |xpos|
      fall_position = puzzle.fall_pack(pack, xpos)
      #puzzle.chain_proc(fall_position)
      if stair_checker(puzzle, fall_position) && !game_over_check(puzzle.width, puzzle.game_stage)
        return xpos
      else
        puzzle.under_line = tmp_under_line.dup
        puzzle.game_stage = Marshal.load(Marshal.dump(tmp_stage))
      end
    end
    return false
  end

  def stair_checker(puzzle, fall_position)
    fall_position.each do |position|
      ypos = position[0] - (puzzle.height-5)
      puts ypos
      xpos = position[1]
      num = puzzle.game_stage[ypos][xpos]
      return false unless stair_flag_checker(ypos,xpos,num)
    end
    return true
  end

  def stair_chain
    turn_num = 10
    0.upto(turn_num-1) do |turn|
      4.times do |rot|
        pack = pack_rotate(Marshal.load(Marshal.dump(@puzzle.pack[turn])), rot)
        stair_fall(@puzzle, pack)
      end
    end
  end
end
