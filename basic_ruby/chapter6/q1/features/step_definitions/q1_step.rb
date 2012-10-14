# encoding: utf-8
require_relative '../../src/q1.rb'

Given /^初期状態$/ do
    @dog = Dog.new
end

When /^Dogクラスをインスタンス化した時$/ do
    @dog = Dog.new  
end

Then /^p dog\.kindを実行すると"(.*?)"が出力される$/ do |arg1|
    @dog.kind.should == arg1
end

When /^dog\.kind = "(.*?)"を実行すると$/ do |arg1|
    @dog.kind = "Chihuahua"
end

Then /^p dog\.kindの出力は"(.*?)"となる$/ do |arg1|
    @dog.kind.should == arg1
end

When /^インスタンス化するときに"(.*?)"を引数として与えると$/ do |arg1|
    @dog = Dog.new("Papillon")
end

Then /^p dog\.kindの出力が"(.*?)"となる$/ do |arg1|
    @dog.kind.should == arg1
end
