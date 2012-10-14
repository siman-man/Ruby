# encoding: utf-8
require_relative '../../src/q1.rb'

Given /^初期状態$/ do
    @q1 = Q1.new
end

When /^fibonacci\(\)を実行すると$/ do
    @result = @q1.fibonacci(1, 2)
end

Then /^フィボナッチ数列が出力される$/ do
    @result[0].should == 2
    @result[1].should == 3
end
