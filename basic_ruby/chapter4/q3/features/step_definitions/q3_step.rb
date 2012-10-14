# encoding: utf-8
require_relative '../../src/q3.rb'

Given /^初期状態$/ do
    @q3 = Q3.new
end

When /^アドレスが渡されると$/ do
    @msg = @q3.split_user_host('user@example.com')
end

Then /^ユーザ部とホスト部が返される$/ do
    @msg[:user].should == 'user'
    @msg[:host].should == 'example.com'
end
