# encoding: utf-8
Feature: 指定した数の*マークを出力する

    print_ast(count)を実行するとcountの数だけ*が出力
    されるような機能。

    Scenario: *を出力
        Given 初期状態
        When print_ast(count)を実行すると
        Then countの数だけ*を出力する
