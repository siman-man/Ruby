require_relative '../lib/lisp.rb'

describe LISP do
  before(:each) do
    @lisp = LISP.new
  end

  it "calc operation test" do
    @lisp[:+,1,2].should == 3
    @lisp[:+,[:+,1,3],2].should == 6
    @lisp[:-,[:+,1,3],2].should == 2
    @lisp[:-,[:+,[:+,1,3], 3],2].should == 5
    @lisp[:*,1,5].should == 5
    @lisp[:/,5,5].should == 1
    @lisp[:==,5,5].should == true
    @lisp[:==,5,4].should == false
  end

  it "get/set variable test" do
    @lisp[:set, :x, 3].should == 3
    @lisp[:set, :y, 5].should == 5
    @lisp[:+, :x, :y].should == 8

    @lisp[:set, :a, 3]
    @lisp[:set, :b, :a].should == 3
    @lisp[:set, :b, 10].should == 10
  end
end
