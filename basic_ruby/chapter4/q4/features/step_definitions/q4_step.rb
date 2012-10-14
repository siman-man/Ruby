# encoding: utf-8
require_relative '../../src/q4.rb'

Given /^初期状態$/ do
    @q4 = Q4.new
end

When /^文字列が渡される$/ do
    @value1 = @q4.msg_calc("1 たす 1")
    @value2 = @q4.msg_calc("1 ひく 1")
    @value3 = @q4.msg_calc("2 かける 3")
    @value4 = @q4.msg_calc("12 わる 2")
end

Then /^計算結果を表示$/ do
    @value1.should == 2
    @value2.should == 0
    @value3.should == 6
    @value4.should == 6
end
