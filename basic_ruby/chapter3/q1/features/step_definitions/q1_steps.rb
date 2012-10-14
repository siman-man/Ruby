# encoding: utf-8
require_relative '../../src/q1.rb'

Given /^devide_three$/ do
    @q = Q1.new
end

When /^引数が渡されたら$/ do
    @msg = @q.devide_three(10)
end

Then /^(\d+)で割った商と余りを返すようにする$/ do |arg1|
    @msg[0].should == 3
    @msg[1].should == 1
end
