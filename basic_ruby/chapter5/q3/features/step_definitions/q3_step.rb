# encoding: utf-8
require_relative '../../src/q3.rb'

Given /^初期状態$/ do
    @q3 = Q3.new
    @array = [ 1, 10, 12, 3, 8, 90, 34, 82 ]
end

When /^asc_order\(array\)を実行すると$/ do
    @msg = @q3.asc_order(@array)
end

Then /^arrayが昇順で出力される$/ do
    @msg.should == [ 1, 3, 8, 10, 12, 34, 82, 90]
end

When /^des_order\(array\)を実行すると$/ do
    @msg = @q3.des_order(@array)
end

Then /^arrayが降順で出力される$/ do
    @msg.should == [ 90, 82, 34, 12, 10, 8, 3, 1]
end

When /^sum\(array\)を実行すると$/ do
    @msg = @q3.sum(@array)
end

Then /^合計値が出力される$/ do
    @msg.should == 240
end

When /^average\(array\)を実行すると$/ do
    @msg = @q3.average(@array)
end

Then /^平均値が出力される$/ do
    @msg.should == 30
end
