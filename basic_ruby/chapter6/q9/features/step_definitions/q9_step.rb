# encoding: utf-8
require_relative '../../src/q9.rb'

Given /^初期状態$/ do
    @ten1 = Yen.new(10)
    @ten2 = Yen.new(10)
    @hund = Yen.new(100)
end

When /^通貨が一緒であり$/ do
    @ten1.currency.should == @ten2.currency
end

When /^かつ金額も一緒であれば$/ do
    @ten1.value.should == @ten2.value
end

Then /^eql\?メソッドはTRUEを返す$/ do
    @ten1.eql?(@ten2).should == TRUE
end

When /^そうでなければ$/ do
    @ten1.value.should_not == @hund.value
end

Then /^eql\?メソッドはFALSEを返す　$/ do
    @ten1.eql?(@hund).should == FALSE
end

When /^通貨が一緒であれば$/ do
    @ten1.currency.should == @hund.currency
end

Then /^eql_currency\?はTRUEを返す$/ do
    @ten1.eql_currency?(@hund).should == TRUE
end
