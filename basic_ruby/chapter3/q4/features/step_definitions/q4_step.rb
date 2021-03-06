# encoding: utf-8
require_relative '../../src/q4.rb'

Given /^初期状態$/ do
    @q4 = Q4.new
end

When /^dice_roll\(\)を実行すると$/ do
    @msg = @q4.dice_roll().to_s
end

Then /^サイコロが振られその値が出力される$/ do
    @msg.should =~ /[1-6]/
end
