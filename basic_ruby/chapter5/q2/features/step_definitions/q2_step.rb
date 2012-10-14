# encoding: utf-8
require_relative '../../src/q2.rb'

Given /^初期状態　$/ do
    @q2 = Q2.new
end

When /^(\d+)次元配列が渡されたら$/ do |arg1|
    one = [ 1, 2, 3, 4, 5, 6]
    @msg = @q2.one_dim2two_dim(one)
end

Then /^(\d+)次元配列にして返す$/ do |arg1|
    @msg[0].should == [ 1, 2, 3]
    @msg[1].should == [ 2, 3, 4]
    @msg[2].should == [ 3, 4, 5]
    @msg[3].should == [ 4, 5, 6]
end
