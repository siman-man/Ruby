# encoding: utf-8
Feature: フィボナッチ数列的な何か

    フィボナッチ数列を作成する関数を作る

    Scenario: フィボナッチ数列を作成
        Given 初期状態
        When fibonacci()を実行すると
        Then フィボナッチ数列が出力される
