require 'spec_helper'
require 'benchmark'

module Codevs
  describe Puzzle do
    before(:all) do
      @puzzle = Puzzle.new
      @orig_sum = @puzzle.sum
      @puzzle.test_init_pack
    end

    before(:each) do
      @puzzle.count = 0
      @puzzle.sum = @orig_sum
      @puzzle.max_chain = 0
      @puzzle.score = 0
      @stage = @puzzle.init_stage
    end

    describe "#benchmark" do
      it "benchmark set_param" do
        @stage[19][0] = 3; @stage[19][1] = 4; @stage[19][2] = 5;
        @stage[20][0] = 3; @stage[20][1] = 4; @stage[20][2] = 5;

        delete_judge_list = []
        delete_list = []
        fall_position = []

        Benchmark.bm do |x|
          x.report("set_param :") { @puzzle.set_param }
          x.report("pack_rotate 0: ") { pack = @puzzle.pack_rotate(@puzzle.pack[0], 0) }
          x.report("pack_rotate 1: ") { pack = @puzzle.pack_rotate(@puzzle.pack[0], 1) }
          x.report("pack_rotate 2: ") { pack = @puzzle.pack_rotate(@puzzle.pack[0], 2) }
          x.report("pack_rotate 3: ") { pack = @puzzle.pack_rotate(@puzzle.pack[0], 3) }
          x.report("check move range: ") { range = @puzzle.check_move_range(@puzzle.pack[1], @puzzle.width) }
          x.report("fall_pack: ") { fall_position = @puzzle.fall_pack(@puzzle.pack[0], 0) }
          x.report("fall_block: ") { @puzzle.fall_block }
          x.report("chain_proc: ") { turn_score = @puzzle.chain_proc(fall_position) }
          x.report("raise level line: ") { @puzzle.raise_level_line(0) }
          x.report("lower level line: ") { @puzzle.lower_level_line(0) }
          x.report("init stage: ") { @puzzle.init_stage }
          x.report("calc score: ") { score = @puzzle.calc_score(1, 4) }
          x.report("delete_judge_list horizontal") do 
            delete_judge_list += @puzzle.delete_judge_list(2, 20, 1, "horizontal")
          end
          x.report("delete_judge_list vertical") do 
            delete_judge_list += @puzzle.delete_judge_list(2, 20, 1, "vertical")
          end
          x.report("delete_judge_list diagonal") do 
            delete_judge_list += @puzzle.delete_judge_list(2, 20, 1, "diagonal")
          end
          x.report("block delete judge") do
            delete_list = @puzzle.block_delete_judge(delete_judge_list.uniq)
          end
          x.report("delete block") do
            @puzzle.delete_block(delete_list)
          end

          x.report("sum_line_block: ") do
            block_line = [[20,0],[20,1],[20,2]]
            sum = @puzzle.sum_line_block(block_line)
          end

          x.report("block line check") do
            line_list = [[20,0],[20,1],[20,2]]
            flag = @puzzle.block_line_check(line_list)
          end
          x.report("game over check") { @puzzle.game_over_check(@puzzle.width, @puzzle.game_stage) }

          x.report("start game simulate: ") do
            operation_list = []
            1000.times do |turn|
              @puzzle.turn = turn+1
              move_point = 0
              rotate = 0
              operation_list << [move_point, rotate]
            end 

            score = @puzzle.start_game_simulate(operation_list)
          end
        end
      end
    end

    describe "#start" do
      it "set point" do
        @puzzle.sum = 10
        @puzzle.point.should == 25

        @puzzle.sum = 20
        @puzzle.set_param
        @puzzle.point.should == 30

        @puzzle.sum = 30
        @puzzle.set_param
        @puzzle.point.should == 35
      end
    end

    describe "#block operation" do
      it "block rotate 2 size" do
        block = [[1,2],[3,4]]

        # -90
        result = block.transpose.map(&:reverse)
        result.should == [[3,1],[4,2]]

        # +90
        result = block.transpose.reverse
        result.should == [[2,4],[1,3]]

        # +180
        result = block.map(&:reverse).reverse
        result.should == [[4,3],[2,1]]
      end

      it "block rotate 3 size" do
        block = [[1,2,3],[4,5,6],[7,8,9]]

        # -90
        result = block.transpose.map(&:reverse)
        result.should == [[7,4,1],[8,5,2],[9,6,3]]

        # +90
        result = block.transpose.reverse
        result.should == [[3,6,9],[2,5,8],[1,4,7]]

        # +180
        result = block.map(&:reverse).reverse
        result.should == [[9,8,7],[6,5,4],[3,2,1]]
      end

      it "block rotate operation" do
        block = [[1,2],[3,4]]
        result = @puzzle.pack_rotate(block, 1)

        result.should == [[3,1],[4,2]]
      end
    end

    describe "#playing game" do
      it "falling block" do
        pack = @puzzle.pack_rotate(@puzzle.pack[1], 0)
        fall_position = @puzzle.fall_pack(pack, 0)
        delete_judge_list = []

        fall_position.each do |position|
          delete_judge_list += @puzzle.delete_judge_list(2, position[0], position[1], "horizontal")
        end
        delete_judge_list.uniq.should == [[[20,0],[20,1]]]
      end

      it "under_line check" do
        @puzzle.raise_level_line(0)
        @puzzle.under_line[0].should == 1 

        @puzzle.lower_level_line(0)
        @puzzle.under_line[0].should == 0
      end

      it "test game over check" do
        @puzzle.game_over_check(@puzzle.width, @puzzle.game_stage).should == false

        @stage[4][0] = 1
        @puzzle.game_over_check(@puzzle.width, @puzzle.game_stage).should == true
      end

      it "judge horizontal range block" do
        @stage[20][0] = 3
        @stage[20][1] = 4
        @stage[20][2] = 5

        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 20, 1, "horizontal")
        judge_list.should == [[[20,0],[20,1]],[[20,1],[20,2]]]
      end

      it "judge vertical range block" do
        @stage[18][0] = 3
        @stage[19][0] = 4
        @stage[20][0] = 5

        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 19, 0, "vertical")
        judge_list.uniq.should == [[[18,0],[19,0]],[[19,0],[20,0]]]
      end

      it "judge diagonal range block" do
        @stage[17][1] = 4
        @stage[18][2] = 2
        @stage[19][1] = 5

        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 18, 2, "diagonal")
        judge_list.uniq.should == [[[17,1],[18,2]],[[19,1],[18,2]]]
      end

      it "judge horizontal and vertical and diagolan range block" do
        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "horizontal")
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "vertical")
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "diagonal")

        judge_list.should == []
      end

      it "sum block line" do
        block_line = [[20,0],[20,1],[20,2]]
        block_line2 = [[19,0],[19,1],[19,2]]
        sum = @puzzle.sum_line_block(block_line)
        sum.should == 0

        @stage[20][0] = 1; @stage[19][0] = 2
        @stage[20][1] = 2; @stage[19][1] = 0
        @stage[20][2] = 3; @stage[19][2] = 3
        sum = @puzzle.sum_line_block(block_line)
        sum.should == 6

        sum = @puzzle.sum_line_block(block_line2)
        sum.should == 0
      end

      it "delete block" do
        block_list = [[20,0],[20,1],[20,2]]
        @stage[19][0] = 3
        @stage[20][0] = 1
        @stage[20][1] = 2
        @stage[20][2] = 3

        @puzzle.delete_block(block_list)
        @stage[19][0].should == 3
        @stage[20][0].should == 0
        @stage[20][1].should == 0
        @stage[20][2].should == 0
      end

      it "fall block" do
        @stage[18][0] = 3; @stage[18][1] = 1
        @stage[19][0] = 2; @stage[19][1] = 0
        @stage[20][0] = 0; @stage[20][1] = 2



        fall_list = @puzzle.fall_block
        @stage[18][0].should == 0; @stage[18][1].should == 0
        @stage[19][0].should == 3; @stage[19][1].should == 1
        @stage[20][0].should == 2; @stage[20][1].should == 2

        fall_list.should == [[20,0],[19,0],[19,1]]
      end

      it "delete judge" do
        @stage[20][0] = 5; @stage[20][1] = 5;
        judge_list = [[[20,0],[20,1]]]

        @puzzle.block_delete_judge(judge_list)
      end

      it "test block line check" do
        line_list = [[20,0],[20,1],[20,2]]
        flag = @puzzle.block_line_check(line_list)
        flag.should == false

        @stage[20][0] = 1
        @stage[20][1] = 2
        flag = @puzzle.block_line_check(line_list)
        flag.should == false

        @stage[20][2] = 3
        flag = @puzzle.block_line_check(line_list)
        flag.should == true
      end

      it "block delete check" do
        delete_list = []
        @stage[17][3] = 1
        @stage[18][3] = 3
        @stage[19][3] = 7
        @stage[20][3] = 2

        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "horizontal")
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "vertical")
        judge_list += @puzzle.delete_judge_list(2, 18, 3, "diagonal")

        judge_list.should == [[[17,3],[18,3]],[[18,3],[19,3]]]

        delete_list += @puzzle.block_delete_judge(judge_list)

        delete_list.should == [[18,3],[19,3]]
        @puzzle.count.should == 2

        @puzzle.delete_block(delete_list)
        @stage[17][3].should == 1
        @stage[18][3].should == 0
        @stage[19][3].should == 0
        @stage[20][3].should == 2


        @puzzle.fall_block


        @stage[17][3].should == 0
        @stage[18][3].should == 0
        @stage[19][3].should == 1
        @stage[20][3].should == 2
      end

      it "block delete check malti" do
        delete_list = []
        @stage[20][0] = 4 
        @stage[20][1] = 6
        @stage[20][2] = 4

        judge_list = []
        judge_list += @puzzle.delete_judge_list(2, 20, 1, "horizontal")
        judge_list += @puzzle.delete_judge_list(2, 20, 1, "vertical")
        judge_list += @puzzle.delete_judge_list(2, 20, 1, "diagonal")

        judge_list.should == [[[20,0],[20,1]],[[20,1],[20,2]]]

        delete_list += @puzzle.block_delete_judge(judge_list)

        delete_list.should == [[20,0],[20,1],[20,2]]
        @puzzle.count.should == 4

        @puzzle.delete_block(delete_list)

        @stage[20][0].should == 0
        @stage[20][1].should == 0
        @stage[20][2].should == 0
      end

      it "check score small" do 
        score = @puzzle.calc_score(1, 2)
        score.should == 2

        score = @puzzle.calc_score(1, 4)
        score.should == 4

        score = @puzzle.calc_score(2, 4)
        score.should == 8
      end

      it "game stream check" do
        0.upto(0) do |turn|
          @puzzle.turn = turn+1
          @puzzle.chain = 1

          delete_judge_list = []
          pack = @puzzle.pack_rotate(@puzzle.pack[turn], 0)
          fall_position = @puzzle.fall_pack(pack, 0)
          unless fall_position.empty?
            @puzzle.count = 0

            fall_position.each do |position|
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "horizontal")
              end
              1.upto(@puzzle.height-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "vertical")
              end
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "diagonal")
              end
            end
            delete_judge_list.uniq.should == [[[20,0]],[[20,0],[20,1]],[[20,0],[19,1]],[[20,1]],[[19,1],[20,1]],[[19,1]]]
            delete_list = @puzzle.block_delete_judge(delete_judge_list.uniq)

            @puzzle.count.should == 2

            score = @puzzle.calc_score(@puzzle.chain, @puzzle.count) if @puzzle.count > 0

            score.should == 2

            delete_list.should == [[20,0],[19,1]]
            @puzzle.delete_block(delete_list)

            fall_position = @puzzle.fall_block
          end
        end
      end

      it "game stream check2" do
        score = 0
        0.upto(4) do |turn|
          @puzzle.turn = turn+1
          @puzzle.chain = 1

          delete_judge_list = []
          pack = @puzzle.pack_rotate(@puzzle.pack[turn], 0)
          fall_position = @puzzle.fall_pack(pack, 0)
          unless fall_position.empty?
            @puzzle.count = 0

            fall_position.each do |position|
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "horizontal")
              end
              1.upto(@puzzle.height-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "vertical")
              end
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "diagonal")
              end
            end
            delete_list = @puzzle.block_delete_judge(delete_judge_list.uniq)

            score += @puzzle.calc_score(@puzzle.chain, @puzzle.count) if @puzzle.count > 0

            @puzzle.delete_block(delete_list)

            fall_position = @puzzle.fall_block
          end
        end
        score.should == 5
        @puzzle.max_chain.should == 1
      end

      it "game stream check3" do
        score = 0
        0.upto(126) do |turn|
          @puzzle.turn = turn+1
          @puzzle.chain = 0

          delete_judge_list = []
          pack = @puzzle.pack_rotate(@puzzle.pack[turn], 0)
          fall_position = @puzzle.fall_pack(pack, 0)
          until fall_position.empty?
            @puzzle.count = 0

            fall_position.each do |position|
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "horizontal")
              end
              1.upto(@puzzle.height-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "vertical")
              end
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "diagonal")
              end
            end
            delete_list = @puzzle.block_delete_judge(delete_judge_list.uniq)

            if @puzzle.count > 0
              @puzzle.chain += 1
              score += @puzzle.calc_score(@puzzle.chain, @puzzle.count)
            end


            @puzzle.delete_block(delete_list)

            fall_position = @puzzle.fall_block
          end
        end
        score.should == 481
        @puzzle.max_chain.should == 3
      end

      it "game stream check4" do
        score = 0
        0.upto(433) do |turn|
          @puzzle.turn = turn+1
          @puzzle.chain = 0

          delete_judge_list = []
          pack = @puzzle.pack_rotate(@puzzle.pack[turn], 1)
          fall_position = @puzzle.fall_pack(pack, 0)
          until fall_position.empty?
            @puzzle.count = 0

            fall_position.each do |position|
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "horizontal")
              end
              1.upto(@puzzle.height-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "vertical")
              end
              1.upto(@puzzle.width-1) do |elem_size|
                delete_judge_list += @puzzle.delete_judge_list(elem_size, position[0], position[1], "diagonal")
              end
            end
            delete_list = @puzzle.block_delete_judge(delete_judge_list.uniq)

            if @puzzle.count > 0
              @puzzle.chain += 1
              score += @puzzle.calc_score(@puzzle.chain, @puzzle.count)
            end


            @puzzle.delete_block(delete_list)

            fall_position = @puzzle.fall_block
          end
        end
        score.should == 1725
        @puzzle.max_chain.should == 4
      end

      it "test game simulate 1" do
        operation_list = []
        1000.times do |turn|
          @puzzle.turn = turn+1
          move_point = 0
          rotate = 0
          operation_list << [move_point, rotate]
        end 

        score = @puzzle.start_game_simulate(operation_list)
        score.should == 479
        @puzzle.max_chain.should == 3
      end

      it "test game simulate 2" do
        operation_list = []
        1000.times do |turn|
          @puzzle.turn = turn+1
          move_point = 0
          rotate = 1
          operation_list << [move_point, rotate]
        end 

        score = @puzzle.start_game_simulate(operation_list)
        score.should == 1725
        @puzzle.max_chain.should == 4
      end

      it "test game simulate 3" do
        operation_list = []
        1000.times do |turn|
          @puzzle.turn = turn+1
          move_point = 0
          rotate = 2
          operation_list << [move_point, rotate]
        end 

        score = @puzzle.start_game_simulate(operation_list)
        score.should == 480
        @puzzle.max_chain.should == 2
      end

      it "test game simulate 4" do
        operation_list = []
        1000.times do |turn|
          @puzzle.turn = turn+1
          move_point = 0
          rotate = 3
          operation_list << [move_point, rotate]
        end 

        score = @puzzle.start_game_simulate(operation_list)
        score.should == 1944
        @puzzle.max_chain.should == 4
      end
    end
  end
end
