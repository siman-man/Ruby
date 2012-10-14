# encoding: utf-8
Feature: インスタンスの初期化について

    インスタンスの初期値をinitializeメソッドを使って実装する

    Scenario: 問題1
        Given 初期状態
        When Dogクラスをインスタンス化した時
        Then p dog.kindを実行すると"Mongrel"が出力される
        When dog.kind = "Chihuahua"を実行すると
        Then p dog.kindの出力は"Chihuahua"となる
        When インスタンス化するときに"Papillon"を引数として与えると
        Then p dog.kindの出力が"Papillon"となる
