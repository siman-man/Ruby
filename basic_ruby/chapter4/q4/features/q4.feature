# encoding: utf-8
Feature: 日本語で計算

    2つの整数と「たす」「ひく」「かける」「わる」という演算子が書かれた文字
    列を解析し、計算結果を表示するコードを作成しなさい。

    Scenario: 日本語用計算プログラム
        Given 初期状態
        When 文字列が渡される
        Then 計算結果を表示
