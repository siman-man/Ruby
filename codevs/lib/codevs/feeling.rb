#!/Users/siman/.rbenv/shims/ruby

class Feeling < Puzzle
  attr_accessor :feeling_line, :dust_line, :feeling_end, :dust_start
  def initialize
    @feeling_line = []
    @dust_line = []
    @puzzle = Puzzle.new
    @puzzle.init_stage
    @puzzle.test_init_pack
  end

  def set_feeling_line(width, size)
    #@feeling_line = Array.new(width/2, 0)
    @feeling_line = Array.new(width, 0)
    #@feeling_end = @feeling_line.size-1
    @feeling_end = width-1
  end

  def set_dust_line(width, size)
    @dust_line = Array.new(width/2-1, 0)
    @dust_start = width - @dust_line.size
  end

  def check_under_line(tmp_under_line, under_line)
    check_line = []
    0.upto(@feeling_end) do |xpos|
      check_line << under_line[xpos]
    end
    sum1 = tmp_under_line.inject(0){|sum,e| sum += e}
    sum2 = check_line.inject(0){|sum,e| sum += e}
    if sum1 <= sum2
    #if under_line == check_line.sort.reverse && sum1 <= sum2
      return true 
    else
      return false
    end
  end

  def check_dust_line(tmp_dust_line, dust_line)
    sum1 = tmp_dust_line.inject(0){|sum,e| sum += e}
    sum2 = dust_line.inject(0){|sum,e| sum += e}
    if sum1 <= sum2 or sum1 >= sum2 && sum1 <= (dust_line.size * (@puzzle.height/4))
      return true 
    else
      return false
    end
  end

  def select_mode(pack)
    pack.each do |line|
      line.each do |elem|
        return "dust" if elem.to_i == @puzzle.sum+1
      end
    end
    return "feeling"
  end

  def check_move_range(pack)
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
    return [-min, @puzzle.width-max-1]
  end

  def check_move_dust_range(pack)
    size = pack.size
    min = size-1
    max = 0
    pack.each do |line|
      line.each_with_index do |elem, index|
        if elem.to_i != 0
          min = index if min > index
          max = index if max < index
        end
      end
    end
    return [@dust_start-min, @puzzle.width-max-1]
  end

  def feeling_fall(puzzle, pack)
    range = check_move_range(pack)
    tmp_under_line = puzzle.under_line.dup
    tmp_stage = Marshal.load(Marshal.dump(puzzle.game_stage))
    fall_position = 0 

    range[0].upto(range[1]) do |pos|
      fall_position = puzzle.fall_pack(pack, pos)
      puzzle.chain_proc(fall_position)
      if check_under_line(tmp_under_line[0..@feeling_end], puzzle.under_line[0..@feeling_end]) && !game_over_check(puzzle.width, puzzle.game_stage)
        return pos
      else 
        puzzle.under_line = tmp_under_line.dup
        puzzle.game_stage = Marshal.load(Marshal.dump(tmp_stage))
      end
    end 
    return false
  end

  def dust_fall(puzzle, pack)
    range = check_move_dust_range(pack)
    tmp_under_line = puzzle.under_line.dup
    tmp_stage = Marshal.load(Marshal.dump(puzzle.game_stage))
    fall_position = 0 

    range[0].upto(range[1]) do |pos|
      fall_position = puzzle.fall_pack(pack, pos)
      puzzle.chain_proc(fall_position)
      if check_dust_line(tmp_under_line[@dust_start..puzzle.width-1], puzzle.under_line[@dust_start..puzzle.width-1]) && !game_over_check(puzzle.width, puzzle.game_stage)
        return pos
      else 
        puzzle.under_line = tmp_under_line.dup
        puzzle.game_stage = Marshal.load(Marshal.dump(tmp_stage))
      end
    end 
    return false
  end

  def select_best_score(puzzle, pack)
    tmp_under_line = puzzle.under_line.dup
    tmp_stage = Marshal.load(Marshal.dump(puzzle.game_stage))
    tmp_pack = Marshal.load(Marshal.dump(pack))
    score = 0
    best_move = []
    4.times do |rot|
      block = puzzle.pack_rotate(Marshal.load(Marshal.dump(tmp_pack)), rot)
      range = check_move_range(block)
      range[0].upto(range[1]) do |pos|
        fall_position = puzzle.fall_pack(block, pos)
        turn_score = puzzle.chain_proc(fall_position)

        if score < turn_score
          score = turn_score
          best_move = [pos, rot]
        end

        puzzle.under_line = tmp_under_line.dup
        puzzle.game_stage = Marshal.load(Marshal.dump(tmp_stage))
      end
    end 
    return best_move
  end

  def feeling_chain
    set_feeling_line(@puzzle.width, @puzzle.size)
    set_dust_line(@puzzle.width, @puzzle.size)
    move_list = []
    count = 0 
    turn_num = 1000
    0.upto(turn_num-1) do |turn|
      flag = false
      #mode = select_mode(@puzzle.pack[turn])
      mode = "feeling"
      until flag
        count = 0 
        4.times do |rot|
          pack = pack_rotate(Marshal.load(Marshal.dump(@puzzle.pack[turn])), rot)
          case mode
          when "feeling"
            pos = feeling_fall(@puzzle, pack.dup)
            if pos != false
              move_list << [pos, rot]
              flag = true
              break
            end 
          when "dust"
            pos = dust_fall(@puzzle, pack.dup)
            if pos != false
              move_list << [pos, rot]
              flag = true
              break
            end 
          when "score"
            move_list << select_best_score(@puzzle, Marshal.load(Marshal.dump(@puzzle.pack[turn])))
            flag = true
            break
          end 
          count += 1
          if count == 4 && flag == false
            mode = "score" if mode == "dust"
            #mode = "dust" if mode == "feeling"
            mode = "score" if mode == "feeling"
          end 
        end 
      end 
    end 
    move_list.each do |move|
      $stdout.print "#{move[0]} #{move[1]}\n"
    end
  end 
end
