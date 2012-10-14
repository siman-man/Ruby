# encoding: utf-8
require_relative '../../src/q2.rb'

Given /^初期状態$/ do
    @q2 = Person.new
end

When /^整数でない値が入力される$/ do
    lambda { @q2.age = "test" }.should raise_error
end

When /^負の値が入力される$/ do
    lambda { @q2.age = -20 }.should raise_error
end
