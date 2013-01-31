require 'spec_helper'
require 'benchmark'

module Evolution
  describe Evol do
    before(:all) do
      @puzzle = Puzzle.new
      @orig_sum = @puzzle.sum
      @puzzle.test_init_pack
    end

    before(:each) do
      @evol = Evol.new
      @puzzle.count = 0
      @puzzle.sum = @orig_sum
      @puzzle.max_chain = 0
      @puzzle.score = 0
      @stage = @puzzle.init_stage
    end

    describe "#benchmark" do
      it "init gene" do
        new_gene = []
        Benchmark.bm do |x|
          x.report("init gene: ") { @evol.init_gene(10, @puzzle.width, @puzzle.size) }
          x.report("init gene hundred: ") { new_gene = @evol.init_gene_hundred(10, @puzzle.width, @puzzle.size) }
          x.report("mutation gene: ") { @evol.mutation_gene(new_gene, @puzzle.width, @puzzle.size) }
        end
      end
    end

    describe "#init" do
      it "create first gene list" do
        init_gene = @evol.init_gene(10, @puzzle.width, @puzzle.size)
        init_gene.size.should == 10

        init_gene.each do |operation_pairs|
          operation_pairs.size.should == 1000

          operation_pairs.each do |operation_pair|
            operation_pair[0].should >= 0
            operation_pair[0].should <= @puzzle.width
            operation_pair[1].should >= 0
            operation_pair[1].should <= 3
          end
        end
      end

      it "simulation all move list" do
        score = 0
        init_gene = @evol.init_gene(10, @puzzle.width, @puzzle.size)

        init_gene.each_with_index do |operation_list, index|
          @stage = @puzzle.init_stage
          #tmp_score = @puzzle.start_game_simulate(operation_list)
          #score = tmp_score if score < tmp_score
          #puts "#{index+1} times end. socre = #{tmp_score.to_i}"
        end
      end

      it "test simple cross gene" do
        a = [[1,0],[2,0],[3,0]]
        b = [[4,0],[5,0],[6,0]]

        new_gene = @evol.simple_cross_gene( a, b, 1)

        new_gene.should == [[1,0],[5,0],[6,0]]
      end

      it "test roulette selection" do
        score_list = [1, 2, 3, 4]

        sum_score = @evol.sum_score(score_list)
        sum_score.should == 10

        select_list = @evol.roulette_selection(score_list)   

        select_list.should == [0,1,1,2,2,2,3,3,3,3]
      end

      it "test ranking selection" do
        score_list = [1,2,3,4,5]

        select_list = @evol.ranking_selection(score_list)

        select_list.should == [4,4,4,4,3,3,2,2,1,0]
      end

      it "test select two different number" do
        num_pair = @evol.select_different_number(10,[4,4,4,4,3,3,2,2,1,0])
        num_pair[0].should >= 0
        num_pair[0].should < 10
        num_pair[1].should >= 0
        num_pair[1].should < 10
      end

      it "test mutation gene" do 
        
      end

      it "test evolution gene" do
        score_list = []
        gene_list = []
        generation_list = []
        score = 0
        elete = 0
        gene_list = @evol.init_gene(3, @puzzle.width, @puzzle.size)

        2.times do |i|
          generation_list = gene_list.dup
          gene_list.each_with_index do |operation_list, index|
            @stage = @puzzle.init_stage

            tmp_score = @puzzle.start_game_simulate(operation_list)
            score_list << tmp_score.to_i
            if score < tmp_score
              elete = index
              score = tmp_score
            end
            puts "#{index+1} times end. socre = #{tmp_score.to_i}"
          end

          gene_list = []
          
          sum_score = @evol.sum_score(score_list) 
          select_list = @evol.roulette_selection(score_list)

          3.times do |i|
            new_gene = []
            num_pair = @evol.select_different_number(select_list.size, select_list)
            new_gene = @evol.simple_cross_gene( generation_list[select_list[num_pair[0]]].dup, generation_list[select_list[num_pair[1]]].dup, rand(1000) )
            @evol.mutation_gene(new_gene, @puzzle.width, @puzzle.size) if Random.rand(100) < 10
            gene_list << new_gene
          end

          gene_list[0] = generation_list[elete].dup
          score_list = []
          score = 0
          puts "#{i+1} generation end"
        end
      end
    end
  end
end
