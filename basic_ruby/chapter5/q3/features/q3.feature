# encoding: utf-8
Feature: 配列を色々変化させて表示させる

    昇順、降順で表示させる。
    合計値を出力
    平均値を出力

    Scenario: いろいろな関数定義
        Given 初期状態
        When asc_order(array)を実行すると
        Then arrayが昇順で出力される
        When des_order(array)を実行すると
        Then arrayが降順で出力される
        When sum(array)を実行すると
        Then 合計値が出力される
        When average(array)を実行すると
        Then 平均値が出力される
