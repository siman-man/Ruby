# encoding: utf-8
require '/Users/siman/Programming/ruby/Ruby/basic_ruby/chapter1/q1/src/q1.rb'

Given /^EXORの状態$/ do
    @q1 = Q1.new
end

When /^TRUE,TRUEと引数が渡されると$/ do
    @value = @q1.ex_or(TRUE, TRUE)
end

Then /^FALSEが返される$/ do
    @value.should == FALSE
end
