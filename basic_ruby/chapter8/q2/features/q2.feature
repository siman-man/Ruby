# encoding: utf-8
Feature: 例外を記述する

    年齢に不正な値を設定しようとしたときに、例外を発生させるようコードを
    完成させなさい。

    Scenario: 例外発生
        Given 初期状態
        When 整数でない値が入力される
        When 負の値が入力される
         