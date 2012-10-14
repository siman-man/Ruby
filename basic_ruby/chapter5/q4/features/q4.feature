# encoding: utf-8
Feature: 1 ~ 12の数字を月名に変換する

    1月から12月までの月を数字を入力するだけで変換してくれる

    Scenario: 月名変換
        Given 初期状態
        When 1が入力されたら
        Then 睦月が返される
        When 2が入力されたら
        Then 如月が返される
        When 3が入力されたら
        Then 弥生が返される
        When 4が入力されたら
        Then 卯月が返される
        When 5が入力されたら
        Then 皐月が返される
        When 6が入力されたら
        Then 水無月が返される
        When 7が入力されたら
        Then 文月が返される
        When 8が入力されたら
        Then 葉月が返される
        When 9が入力されたら
        Then 長月が返される
        When 10が入力されたら
        Then 神無月が返される
        When 11が入力されたら
        Then 霜月が返される
        When 12が入力されたら
        Then 師走が返される

