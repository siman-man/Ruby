# encoding: utf-8
require_relative '../../src/q3.rb'

Given /^初期状態$/ do
    @q3 = Q3.new
end

When /^ユーザ名がserver_errorならサーバエラーが発生$/ do
    lambda { @q3.access('server_error', 'ppp') }.should raise_error
end

When /^ユーザ名を入力\(users\)に含まれている$/ do
    @msg = @q3.access('user1', 'pass1')
end

Then /^ログインできる$/ do
    @msg.should == "ログイン完了"
end

When /^ユーザ名を入力\(users\)に含まれていない$/ do
    @msg = @q3.access('user21', 'pass1')
end

Then /^ログインできない$/ do
    @msg.should == "ログイン失敗"
end

