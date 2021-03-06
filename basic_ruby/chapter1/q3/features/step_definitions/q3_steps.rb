# encoding: utf-8
require_relative '../../src/q3.rb'

When /^初期状態$/ do
    @q3 = Q3.new
end

When /^(\d+)の倍数になると$/ do |arg1|
    @msg = @q3.return_message(3)
end

Then /^文章を出力する$/ do
    @msg.should == "Hello Ruby\n"
end

When /^(\d+)の倍数であり$/ do |arg1|
    @msg = @q3.return_message(arg1)
end

When /^(\d+)の倍数ならば$/ do |arg1|
    @msg = @q3.return_message(15)
end

Then /^別の文章を出力する$/ do
    @msg.should == "This argument is a multiple of 5\n"
end
