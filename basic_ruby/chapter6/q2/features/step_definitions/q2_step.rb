# encoding: utf-8
require_relative '../../src/q2.rb'

Given /^初期状態$/ do
    @dog = Dog.new
end

When /^Dogクラスをインスタンス化した時$/ do
    @dog = Dog.new  
end

Then /^p dog\.kindを実行すると"(.*?)"が出力される$/ do |arg1|
    @dog.kind.should == arg1
end

When /^インスタンス化するときに"(.*?)"を引数として与えると$/ do |arg1|
    @dog = Dog.new("Papillon")
end

Then /^p dog\.kindの出力が"(.*?)"となる$/ do |arg1|
    @dog.kind.should == arg1
end

Then /^kindに書き込みをしようとするとエラーが出力される$/ do
    lambda { @dog.kind = "Papillong" }.should raise_error
end

When /^mealメソッドに文字列を渡すと$/ do
    @dog.meal("meet")
end

Then /^エサが与えられた状態になる$/ do
    @dog.bait.should == "OK"
end

When /^エサが与えられている状態でfeelingメソッドを実行する$/ do
    @dog.bait.should == "OK"
    @msg = @dog.feeling
end

Then /^"(.*?)"が返される$/ do |arg1|
    @msg.should == arg1
end

When /^エサがなくなっている場合にfeelingメソッドを実行する$/ do
    @dog.bait.should == "NO"
    @msg = @dog.feeling
end
