# encoding: utf-8
Feature: 引数の有無で処理を分ける

    ブロック省略時には単に引数nを表示するように変更しなさい

    Scenario: 引数の有無で処理を分ける
        Given 初期状態
        When ブロックがある場合にmethod2(3)を実行すると
        Then 9を返す
        When ブロックがない場合は
        Then 引数nを返す
