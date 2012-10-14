# encoding: utf-8
Feature: ブロックの様々な実行方法について

    ブロックを実行するメソッドを、ブロックの実行方法を変えて
    2通りの方法で完成させなさい

    Scenario: 様々なブロック実装
        Given 初期状態
        When method1(3)を実行すると
        Then 9が返ってくる
