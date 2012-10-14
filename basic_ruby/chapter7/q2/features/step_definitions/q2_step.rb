# encoding: utf-8
require_relative '../../src/q2.rb'

Given /^初期状態$/ do
    @q2 = Q2.new
end

When /^method(\d+)\((\d+)\)を実行すると$/ do |arg1, arg2|
    @value = @q2.method1(arg2.to_f) {|x| x * x }
end

Then /^(\d+)が返ってくる$/ do |arg1|
    @value.should == arg1.to_f
end
