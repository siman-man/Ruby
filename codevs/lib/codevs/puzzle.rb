#!/Users/siman/.rbenv/shims/ruby
require 'thread'
#require 'fiber'

class Puzzle
  attr_accessor :under_line, :count, :chain, :sum, :max_chain, :score, :game_stage, :turn
  attr_reader :point, :pack, :width, :height, :size


  def initialize
    @io = File.open("/Users/siman/Programming/codevs/lib/codevs/sample_input.txt", "r")
    #@io = File.open("/Users/siman/Programming/codevs/lib/codevs/sample_input_middle.txt", "r")
    #@io = File.open("/Users/siman/Programming/codevs/lib/codevs/sample_input_large.txt", "r")
    #argv = $stdin.gets.split()
    argv = @io.readline.split()
    @width = argv[0].to_i
    @height = argv[1].to_i + 5
    @size = argv[2].to_i
    @sum = argv[3].to_i
    @step = argv[4].to_i
    @count = 0
    @turn = 0
    @chain = 0
    @score = 0
    @max_chain = 0
    @point = 0
    @max_level = 0
    @delete_judge_list = []

    @pack = Array.new(@step).map!{ Array.new(@size).map! { Array.new(@size) }}
  end

  def check_move_range(pack, width)
    size = pack.size
    min = size - 1
    max = 0
    pack.each do |line|
      line.each_with_index do |elem, index|
        if elem != "0"
          min = index if min > index
          max = index if max < index
        end
      end
    end
    return [-min, width-max-1]
  end

  def set_param
    case @sum
    when 10
      @point = 25
    when 20
      @point = 30
    when 30
      @point = 35
    end
  end

  def init_pack
    (0..@step-1).each do |i|
      (0..@size-1).each do |j|
        elem = $stdin.gets.split()
        (0..@size-1).each do |k|
          @pack[i][j][k] = elem[k]
        end
      end
      endstr = $stdin.gets
    end
  end

  def test_init_pack
    (0..@step-1).each do |i|
      (0..@size-1).each do |j|
        elem = @io.readline.split()
        (0..@size-1).each do |k|
          @pack[i][j][k] = elem[k]
        end
      end
      elem = @io.readline.split()
    end
  end

  def init_stage
    @under_line = Array.new(@width, 0)
    @game_stage = Array.new(@height).map!{ Array.new(@width, 0) }
  end

  def calc_score(chain, count)
    @max_chain = chain if @max_chain < chain
    n = @turn/100
    ([1,chain-(@point-n)+1].max*count) * (2**([chain,@point+n].min-1))
  end

  def block_delete_judge(judge_list)
    delete_list = []
    judge_list.each do |line_list|
      sum = sum_line_block(line_list)
      if sum == @sum
        @count += line_list.size
        line_list.each do |block|
          delete_list << [block[0],block[1]]
        end 
      end 
    end
    return delete_list.uniq
  end

  def raise_level_line(xpos)
    if 0 <= @under_line[xpos] && @under_line[xpos] < @height
      @under_line[xpos] += 1 
      @max_level = @under_line.max
    end
  end

  def lower_level_line(xpos)
    if 0 < @under_line[xpos] && @under_line[xpos] <= @height 
      @under_line[xpos] -= 1 
      @max_level = @under_line.max
    end
  end

  def block_line_check(block_line)
    block_line.each do |block|
      if block[0] < 0 || @height-1 < block[0] || block[1] < 0 || @width-1 < block[1]
        return false
      elsif @game_stage[block[0]][block[1]] == 0
        return false
      end
    end
    return true
  end

  def delete_judge_list(elem_num, ypos, xpos, direct_kind)
    judge_list = []
    case direct_kind
    when "horizontal"
      1.upto(elem_num) do |i|
        line_list = [] 
        elem_num.times do |e|
          line_list << [ypos,xpos-(elem_num-i)+e]
        end
        judge_list << line_list if block_line_check(line_list)
      end
    when "vertical"
      1.upto(elem_num) do |i|
        line_list = []
        elem_num.times do |e|
          line_list << [ypos-(elem_num-i)+e, xpos]
        end
        judge_list << line_list if block_line_check(line_list)
      end
    when "diagonal"
      1.upto(elem_num) do |i|
        line_list = []
        elem_num.times do |e|
          line_list << [ypos-(elem_num-i)+e, xpos-(elem_num-i)+e]
        end
        judge_list << line_list if block_line_check(line_list)
      end

      1.upto(elem_num) do |i|
        line_list = []
        elem_num.times do |e|
          line_list << [ypos+(elem_num-i)-e, xpos-(elem_num-i)+e]
        end
        judge_list << line_list if block_line_check(line_list)
      end
    end
    return judge_list
  end

  def sum_line_block(line_list)
    sum = 0
    if block_line_check(line_list)
      line_list.each do |block_pos|
        sum += @game_stage[block_pos[0]][block_pos[1]].to_i
        return 0 if @game_stage[block_pos[0]][block_pos[1]] == "0"
      end
    end
    sum 
  end

  def delete_block(block_list)
    block_list.each do |block|
      @game_stage[block[0]][block[1]] = 0
      lower_level_line(block[1])
    end
  end

  def exec_fall_block(ypos, xpos)
    (@height-1).downto(ypos+1) do |y|
      if @game_stage[y][xpos] == 0
        @game_stage[y][xpos] = @game_stage[ypos][xpos]
        @game_stage[ypos][xpos] = 0
        return [y,xpos]
      end
    end
  end

  def fall_block
    fall_list = []
    (@height-2).downto(0) do |y|
      0.upto(@width-1) do |x|
        if @game_stage[y][x] != 0 && @game_stage[y+1][x] == 0
          fall_list << exec_fall_block(y,x)
        end
      end
    end
    return fall_list
  end

  def fall_pack(pack, xpos)
    fall_position_list = []

    (@size-1).downto(0) do |i|
      pack[i].each_with_index do |elem, index|
        if elem != "0"
          y = @height-(@under_line[xpos+index]+1)
          x = xpos+index
          @game_stage[y][x] = elem
          raise_level_line(xpos+index)
          fall_position_list << [y,x]
        end
      end
    end
    fall_position_list
  end

  def pack_rotate(pack, rot)
    case rot
    when 0
      pack
    when 1
      pack.transpose.map(&:reverse)
    when 2
      pack.map(&:reverse).reverse
    when 3
      pack.transpose.reverse
    end
  end

  def render_stage
    print "\n"
    @game_stage.each do |line|
      line.each do |elem|
        if elem == "11"
          print sprintf("%2s", "B")
        else
          print sprintf("%2d", elem.to_s)
        end
      end
      print "\n"
    end
  end

  def render_block(pack)
    print "\n"
    pack.each do |line|
      line.each do |elem|
        print sprintf("%2d", elem.to_s)
      end
      print "\n"
    end
  end

  def get_line(position)
    1.upto(@width-(@game_stage[position[0]][position[1]].to_i-1)) do |elem_size|
      @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "horizontal")
      @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "diagonal")
    end
  end

  def get_line2(position)
    1.upto(@under_line[position[1]]) do |elem_size|
      @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "vertical")
    end
  end

  def chain_proc(fall_position)
    turn_score = 0
    @chain = 0

    until fall_position.empty?
      @count = 0
      @delete_judge_list = []
      thread_max = 4
      threads = []
      fibers = []

      #fall_position.each do |position|
      #  fibers << Fiber.new {
      #    get_line(position)
      #    get_line2(position)
      #  }
      #end

      fall_position.each do |position|
        1.upto(@width-(@game_stage[position[0]][position[1]].to_i-1)) do |elem_size|
          @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "horizontal")
          @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "diagonal")
        end
        1.upto(@under_line[position[1]]) do |elem_size|
          @delete_judge_list += delete_judge_list(elem_size, position[0], position[1], "vertical")
        end
      end

      #fibers.each do |f|
      #  f.resume
      #end

      delete_list = block_delete_judge(@delete_judge_list.uniq)

      if @count > 0 
        @chain += 1
        turn_score += calc_score(chain, count)
      end 

      delete_block(delete_list)

      fall_position = fall_block
    end

    return turn_score
  end

  def start_game_simulate(move_list, turn=0)
    score = 0
    move_list.each do |operation|
      pack = pack_rotate(@pack[turn], operation[1])
      fall_position = fall_pack(pack, operation[0])
      turn_score = chain_proc(fall_position)
      return score if game_over_check(@width, @game_stage)
      score += turn_score
      turn += 1
    end
    return score
  end

  def start_game_simulate_gene(move_list, turn=0)
    score = 0
    move_list.each do |operation|
      pack = pack_rotate(@pack[turn], operation[1])
      fall_position = fall_pack(pack, operation[0])
      turn_score = chain_proc(fall_position)
      return 0 if game_over_check(@width, @game_stage)
      score += turn_score
      turn += 1
    end
    return score
  end


  def game_over_check(width, game_stage)
    0.upto(width-1) do |i|
      return true if game_stage[4][i] != 0
    end
    return false
  end
end
