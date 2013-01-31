require 'spec_helper'

module Stairs
  describe Stair do
    before(:all) do
      @puzzle = Puzzle.new
      @puzzle.test_init_pack
    end

    before(:each) do
      @stage = @puzzle.init_stage
      @stair = Stair.new
    end

    describe "#playing game" do
      it "test un breaking block line cheker" do
        @stage[15][0] = 5
        @stair.un_block_cheker(@puzzle).should == false

        @stage[15][0] = 11
        @stair.un_block_cheker(@puzzle).should == true
      end

      it "test check stair" do
        @stair.stair_flag_setter( 0, 0, 3, false)
        @stair.stair_flag_checker( 0, 0, 3).should == false
      end

      it "test move range" do
        pack = [[0,0,0,0],[3,2,0,0],[0,0,0,0],[0,0,0,1]]
        range = @stair.check_stair_move_range(pack, @puzzle.width/2+3)
        range.should == [0,4]
      end

      it "test stair chain" do
        turn_num = 10
        0.upto(turn_num-1) do |turn|
          4.times do |rot|
            pack = @puzzle.pack_rotate(Marshal.load(Marshal.dump(@puzzle.pack[turn])), rot)
            @stair.stair_chain
          end
        end
        @puzzle.render_stage
      end
    end
  end
end
