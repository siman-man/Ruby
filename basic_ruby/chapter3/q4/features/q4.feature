# encoding: utf-8
Feature: 3つのサイコロを振る

    3つのサイコロを振ってその合計値を表示する

    Scenario: 3つのサイコロを振ってその合計値を出力
        Given 初期状態
        When dice_roll()を実行すると
        Then サイコロが振られその値が出力される
