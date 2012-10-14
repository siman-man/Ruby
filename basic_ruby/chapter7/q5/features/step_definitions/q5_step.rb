# encoding: utf-8
require_relative '../../src/q5.rb'

Given /^初期状態$/ do
    @q5 = Q5.new
end

When /^make_gs_gen\((\d+),(\d+)\)をオブジェクト化して実行すると$/ do |arg1, arg2|
    @gen = @q5.make_gs_gen(arg1.to_f, arg2.to_f)
end

Then /^(\d+)回目のcallでは(\d+)が出力される$/ do |arg1, arg2|
    @gen.call.should == arg2.to_f
end
