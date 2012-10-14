# encoding: utf-8
require_relative '../../src/q7.rb'

Given /^初期状態$/ do
    @person = Person.new
    @fighter = Fighter.new
    @wizard = Wizard.new
end

When /^base_strengthを実行する$/ do
    @strength = @person.base_strength
end

Then /^元のstrengthの値が取得できる$/ do
    @strength.should == @person.strength
end

When /^base_clevernessを実行する$/ do
    @cleverness = @person.base_cleverness
end

Then /^元のclevernessの値が取得できる$/ do
    @cleverness.should == @person.cleverness
end

When /^Fighterクラスのstrengthを参照する$/ do
    @strength = @fighter.strength
end

Then /^元の値の1.5倍になっている$/ do 
    @strength.should == @fighter.base_strength * 1.5
end

When /^Fighterクラスのclevernessを参照する$/ do
    @cleverness = @fighter.cleverness
end

Then /^元の値から変化していない$/ do
    @cleverness.should == @fighter.base_cleverness
end

When /^Wizardクラスのstrengthを参照する$/ do
    @strength = @wizard.strength
end

Then /^元の値の半分になる$/ do
    @strength.should == @wizard.base_strength * 0.5
end

When /^Wizardクラスのclevernessを参照する$/ do
    @cleverness = @wizard.cleverness
end

Then /^元の値の(\d+)倍になる$/ do |arg1|
    @cleverness.should == @wizard.base_cleverness * arg1.to_f
end

