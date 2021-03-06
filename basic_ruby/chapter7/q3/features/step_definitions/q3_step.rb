# encoding: utf-8
require_relative '../../src/q3.rb'

Given /^初期状態$/ do
    @q3 = Q3.new
end

When /^ブロックがある場合にmethod(\d+)\((\d+)\)を実行すると$/ do |arg1, arg2|
    @value = @q3.method2(arg2.to_f) {|x| p x * x }
end

Then /^(\d+)を返す$/ do |arg1|
    @value.should == arg1.to_f
end

When /^ブロックがない場合は$/ do
    @value = @q3.method2(3)
end

Then /^引数nを返す$/ do
    @value = 3
end
