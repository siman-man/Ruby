# encoding: utf-8
Feature: メソッドの置き換え

    Moneyクラスには、通貨で比較するeql?メソッドが定義されている。
    サブクラスのYenでは、このメソッドを通過と金額で比較するように置き換えたい。
    ただし、元の通貨の比較はeql_currency?として残しておきたい。期待する
    動作をするようコードを完成させなさい。

    Scenario: メソッドの置き換え
        Given 初期状態
        When 通貨が一緒であり
        And かつ金額も一緒であれば
        Then eql?メソッドはTRUEを返す
        When そうでなければ
        Then eql?メソッドはFALSEを返す　
        When 通貨が一緒であれば
        Then eql_currency?はTRUEを返す
