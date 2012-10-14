# encoding: utf-8
require_relative '../../src/q4.rb'

Given /^初期状態$/ do
    @q4 = Q4.new
end

When /^(\d+)が入力されたら$/ do |arg1|
    @msg = @q4.month_conv_jp(arg1)
end

Then /^睦月が返される$/ do
    @msg.should == "睦月"
end

Then /^如月が返される$/ do
    @msg.should == "如月"
end

Then /^弥生が返される$/ do
    @msg.should == "弥生"
end

Then /^卯月が返される$/ do
    @msg.should == "卯月"
end

Then /^皐月が返される$/ do
    @msg.should == "皐月"
end

Then /^水無月が返される$/ do
    @msg.should == "水無月"
end

Then /^文月が返される$/ do
    @msg.should == "文月"
end

Then /^葉月が返される$/ do
    @msg.should == "葉月"
end

Then /^長月が返される$/ do
    @msg.should == "長月"
end

Then /^神無月が返される$/ do
    @msg.should == "神無月"
end

Then /^霜月が返される$/ do
    @msg.should == "霜月"
end

Then /^師走が返される$/ do
    @msg.should == "師走"
end
