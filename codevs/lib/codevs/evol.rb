#!/Users/siman/.rbenv/shims/ruby

class Evol
  attr_accessor :elete_gene

  def initialize
    @elete_gene = []
    @puzzle = Puzzle.new
    @puzzle.init_stage
    @rank_num = 5
    @rank = [4,2,2,1,1]
  end

  def init_gene(count, width, size)
    gene_list = []
    count.times do |i|
      operation_list = []
      1000.times do |turn|
        move_point = rand(width-size+1)
        rotate = rand(4)
        operation_list << [move_point, rotate]
      end 
      gene_list << operation_list
    end 
    return gene_list
  end

  def init_gene_hundred(count, width, size)
    gene_list = []
    count.times do |i|
      operation_list = []
      100.times do |turn|
        move_point = rand(width-size+1)
        rotate = rand(4)
        operation_list << [move_point, rotate]
      end 
      gene_list << operation_list
    end 
    return gene_list
  end

  def mutation_gene(gene, width, size)
    change_list = []
    20.times {|i| change_list << rand(100)}

    change_list.each do |elem|
      move_point = rand(width-size+1)
      rotate = rand(4)

      gene[elem] = [move_point, rotate]
    end
  end

  def simple_cross_gene(parent1, parent2, cross_point)
    new_gene = []
    0.upto(parent1.size-1) do |i|
      if i < cross_point
        new_gene << parent1[i]
      else
        new_gene << parent2[i]
      end
    end
    return new_gene
  end

  def roulette_selection(score_list)
    sum_score = sum_score(score_list)
    roulette_list = []
    score_list.each_with_index do |score,index|
      score.times {roulette_list << index}
    end
    return roulette_list
  end

  def ranking_selection(score_list)
    i = 0
    ranking_list = Array.new(10,0)
    @rank_num.times do |num|
      index = score_list.rindex(score_list.max)    
      @rank[num].times do 
        ranking_list[i] = index
        i += 1
      end
      score_list[index] = 0
    end
    return ranking_list
  end

  def sum_score(score_list)
    (score_list).inject(0){|sum,e| sum+=e}
  end

  def select_different_number(size, select_list)
    while true
      rand1 = rand(size)
      rand2 = rand(size)
      index1 = select_list[rand1]
      index2 = select_list[rand2]
      if index1 != index2
        return [rand1,rand2] 
      end
    end
  end

  def gene_evolution
    gene_num = 30
    evol_count = 10
    gene_list = []
    generation_list = []
    final_gene = []
    best_under_line = []
    best_game_stage = []
    best_gene = []
    #@puzzle.test_init_pack
    @puzzle.init_pack
    @puzzle.set_param
    #gene_list = init_gene(gene_num, @puzzle.width, @puzzle.size)


    10.times do |divide|

      #puts "start #{100*divide} - #{100*(divide+1)}"
      tmp_stage = Marshal.load(Marshal.dump(@puzzle.game_stage))
      tmp_under_line = @puzzle.under_line.dup
      gene_list = init_gene_hundred(gene_num, @puzzle.width, @puzzle.size)
      #@puzzle.render_stage
      #@puzzle.init_stage
      #puts @puzzle.start_game_simulate(final_gene)
      #@puzzle.render_stage
      #puts "-----------"

      evol_count.times do |i|
        score_list = []
        elete = 0
        score = 0

        generation_list = Marshal.load(Marshal.dump(gene_list))

        generation_list.each_with_index do |operation_list, index|
          @puzzle.under_line = tmp_under_line.dup
          @puzzle.game_stage = Marshal.load(Marshal.dump(tmp_stage))

          tmp_score = @puzzle.start_game_simulate_gene(operation_list, 100*divide)
          score_list << tmp_score.to_i
          if score < tmp_score
            best_under_line = @puzzle.under_line.dup
            best_game_stage = Marshal.load(Marshal.dump(@puzzle.game_stage))
            best_gene = Marshal.load(Marshal.dump(operation_list)) 
            elete = index
            score = tmp_score
          end
          #puts "#{index+1} times end. socre = #{tmp_score.to_i}"
        end

        gene_list = []

        sum_score = sum_score(score_list)
        #select_list = roulette_selection(score_list)
        select_list = ranking_selection(score_list)

        gene_num.times do |i|
          new_gene = []
          num_pair = select_different_number(select_list.size, select_list)
          parent1 = Marshal.load(Marshal.dump(generation_list[select_list[num_pair[0]]]))
          parent2 = Marshal.load(Marshal.dump(generation_list[select_list[num_pair[1]]]))
          #new_gene = simple_cross_gene( generation_list[select_list[num_pair[0]]].dup, generation_list[select_list[num_pair[1]]].dup, rand(1000) )
          new_gene = simple_cross_gene( parent1, parent2, rand(100) )
          mutation_gene(new_gene, @puzzle.width, @puzzle.size) if rand(100) < 30
          gene_list << new_gene
        end

        #gene_list[0] = generation_list[elete].dup
        gene_list[0] = Marshal.load(Marshal.dump(generation_list[elete]))  
      end

      @puzzle.under_line = best_under_line.dup
      @puzzle.game_stage = Marshal.load(Marshal.dump(best_game_stage))
      final_gene += best_gene
    end

    final_gene.each do |gene|
      $stdout.print "#{gene[0]} #{gene[1]}\n"
    end
  end
end
