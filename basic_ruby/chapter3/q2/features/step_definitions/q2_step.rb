# encoding: utf-8
require_relative '../../src/q2.rb'

Given /^初期状態$/ do
    @q2 = Q2.new
end

When /^値が渡されると$/ do
   @value1 = @q2.round_off(5.04)
   @value2 = @q2.round_off(5.05)
end

Then /^小数点以下(\d+)桁で四捨五入した値を返す$/ do |arg1|
    @value1.should == 5.0
    @value2.should == 5.1
end
