require 'spec_helper'

module Feel
  describe Feeling do
    before(:all) do
      @puzzle = Puzzle.new
      @puzzle.test_init_pack
    end

    before(:each) do
      @stage = @puzzle.init_stage
      @feeling = Feeling.new
      @feeling.set_feeling_line(10, 4)
      @feeling.set_dust_line(10, 4)
    end

    describe "#init" do
      it "set feeling_line" do
        width = 10
        size = 4
        @feeling.set_feeling_line(width, size)
        #@feeling.feeling_line.size.should == 5
        @feeling.feeling_end.should == 4
      end

      it "set dust line" do
        width = 10
        size = 4
        @feeling.set_dust_line(width, size)
        @feeling.dust_line.size.should == 4
        @feeling.dust_start.should == 6
      end

      it "check feeling move range" do
        width = 10
        size = 4
        @feeling.set_feeling_line(width, size)
        pack1 = [[1,2,3],[4,5,6],[7,8,9]]
        range = @feeling.check_move_range(pack1)
        range.should == [0,1]

        pack2 = [[0,2,3],[0,5,6],[0,8,9]]
        range = @feeling.check_move_range(pack2)
        range.should == [-1,1]

        pack3 = [[0,0,3],[0,0,6],[0,0,9]]
        range = @feeling.check_move_range(pack3)
        range.should == [-2,1]

        pack4 = [[0,2,3],[0,0,6],[0,0,0]]
        range = @feeling.check_move_range(pack4)
        range.should == [-1,1]

        pack5 = [[1,0,3],[0,5,0],[7,0,9]]
        range = @feeling.check_move_range(pack5)
        range.should == [0,1]

        pack6 = [[1,0,0],[0,0,0],[7,0,0]]
        range = @feeling.check_move_range(pack6)
        range.should == [0,3]

        pack7 = [[0,0,0,0],[3,2,0,0],[0,0,0,0],[0,0,0,1]]
        range = @feeling.check_move_range(pack7)
        range.should == [0,1]

      end

      it "check dust move range" do
        width = 10
        size = 4
        @feeling.set_dust_line(width, size)
        pack1 = [[1,2,3],[4,5,6],[7,8,9]]
        range = @feeling.check_move_dust_range(pack1)
        range.should == [6,7]

        pack2 = [[0,2,3],[0,5,6],[0,8,9]]
        range = @feeling.check_move_dust_range(pack2)
        range.should == [5,7]

        pack3 = [[0,0,3],[0,0,6],[0,0,9]]
        range = @feeling.check_move_dust_range(pack3)
        range.should == [4,7]

        pack4 = [[0,2,3],[0,0,6],[0,0,0]]
        range = @feeling.check_move_dust_range(pack4)
        range.should == [5,7]

        pack5 = [[1,0,3],[0,5,0],[7,0,9]]
        range = @feeling.check_move_dust_range(pack5)
        range.should == [6,7]

        pack6 = [[1,0,0],[0,0,0],[7,0,0]]
        range = @feeling.check_move_dust_range(pack6)
        range.should == [6,9]

        pack7 = [[6,0,0,0],[0,0,6,0],[0,0,0,0],[0,11,0,2]]
        range = @feeling.check_move_dust_range(pack7)
        range.should == [6,6]

        pack8 = [[0,0,0,1],[0,0,0,0],[0,2,0,0],[0,3,0,0]]
        range = @feeling.check_move_dust_range(pack8)
        range.should == [5,6]
      end

      it "check under line" do
        @puzzle.under_line[0] = 3
        @puzzle.under_line[1] = 2
        @puzzle.under_line[2] = 1        

        feeling_line = [2,2,1]

        under_line = @puzzle.under_line[0..@feeling.feeling_end].dup
        @feeling.check_under_line(feeling_line, under_line).should == true
        @feeling.game_over_check(@puzzle.width, @stage) == false

        @puzzle.under_line[0] = 2
        @puzzle.under_line[1] = 3
        @puzzle.under_line[2] = 1        

        feeling_line = [2,2,1]

        under_line = @puzzle.under_line[0..@feeling.feeling_end].dup
        @feeling.check_under_line(feeling_line, under_line).should == false

        @puzzle.under_line[0] = 2
        @puzzle.under_line[1] = 2
        @puzzle.under_line[2] = 1        

        feeling_line = [2,2,1]

        under_line = @puzzle.under_line[0..@feeling.feeling_end].dup
        @feeling.check_under_line(feeling_line, under_line).should == true

        @puzzle.under_line[0] = 2
        @puzzle.under_line[1] = 2
        @puzzle.under_line[2] = 1        

        feeling_line = [3,2,1]

        under_line = @puzzle.under_line[0..@feeling.feeling_end].dup
        @feeling.check_under_line(feeling_line, under_line).should == false
      end

      it "test select mode" do
        pack1 = [[1,2,3],[4,5,6],[7,8,11]]
        mode = @feeling.select_mode(pack1)
        mode.should == "dust"

        pack2 = [[1,2,3],[4,5,6],[7,8,9]]
        mode = @feeling.select_mode(pack2)
        mode.should == "feeling"

        mode = @feeling.select_mode(@puzzle.pack[37])
        mode.should == "dust"
      end

      it "check dust line" do
        @puzzle.under_line[6] = 2
        @puzzle.under_line[7] = 1
        @puzzle.under_line[8] = 3

        dust_line = [1,2,1,0]
        under_line = @puzzle.under_line[@feeling.dust_start..-1].dup
        @feeling.check_dust_line(dust_line, under_line).should == true
      end

      it "test feeling mode" do
        pack = @puzzle.pack_rotate(@puzzle.pack[0], 0)
        @feeling.feeling_fall(@puzzle, pack).should == false

        @stage[20][4].should == 0

        pack = @puzzle.pack_rotate(@puzzle.pack[0], 1)
        @feeling.feeling_fall(@puzzle, pack).should == 0

      end

      it "test feeling block stack" do
        mode = "feeling"
        0.upto(4) do |turn|
          4.times do |rot|
            pack = @puzzle.pack_rotate(@puzzle.pack[turn], rot)
            break if @feeling.feeling_fall(@puzzle, pack)
            mode = "dust" if rot == 3
          end
          mode.should_not == "dust"
        end
      end

      it "test dust block stack" do
        mode = "dust"
        dust_list = [37,69,97,103,116,171,175,195,206,247]
        dust_list.each do |turn|
          4.times do |rot|
            pack = @puzzle.pack_rotate(@puzzle.pack[turn], rot)
            break if @feeling.dust_fall(@puzzle, pack)
            mode = "score" if rot == 3
          end
          mode.should_not == "score"
        end
      end

      it "test score mode" do
        mode = "score"
        pack = [[11,11,11,11],[11,11,11,11],[11,11,11,11],[5,11,11,11]]
        @puzzle.render_block(pack)
        @stage[20][0] = 5
        @puzzle.under_line[0] += 1

        best_move = @feeling.select_best_score(@puzzle, pack)

        best_move.should == [0,0]
      end

      it "test feeling stuck stream" do
        move_list = []
        count = 0
        turn_num = 100
        0.upto(turn_num-1) do |turn|
          puts "start turn #{turn}"
          flag = false
          #mode = @feeling.select_mode(@puzzle.pack[turn])
          mode = "feeling"
          until flag
            count = 0
            4.times do |rot|
              pack = @puzzle.pack_rotate(Marshal.load(Marshal.dump(@puzzle.pack[turn])), rot)
              case mode
              when "feeling"
                pos = @feeling.feeling_fall(@puzzle, pack)
                if pos != false
                  move_list << [pos, rot]
                  flag = true
                  break
                end
              when "dust"
                pos = @feeling.dust_fall(@puzzle, pack)
                if pos != false
                  move_list << [pos, rot]
                  flag = true
                  break
                end
              when "score"
                move_list << @feeling.select_best_score(@puzzle, Marshal.load(Marshal.dump(@puzzle.pack[turn])))
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
        @puzzle.render_stage
        p move_list
        move_list.size.should == turn_num
      end
    end
  end
end
