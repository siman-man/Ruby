# encoding: utf-8
Feature: 引数によって出力する文章が変化する

    1から100までの整数から
    3の倍数のみを表示する
    3の倍数のうち5の倍数でないものを表示するコードも書く

        Scenario: hundred_print()を呼び出すと
            Given 初期状態
            When 3の倍数になると
            Then 文章を出力する

            When 3の倍数であり
            And  5の倍数ならば
            Then 別の文章を出力する
