# encoding: utf-8
Feature: メールアドレスからユーザ部とホスト部を切り分ける

    渡されたメールアドレスをユーザ部とホスト部に切り分ける。
    例) user@host.example.comの場合、ユーザ部はuser。ホスト部は
    host.example.com

    Scenario: ホストとユーザの切り分け
        Given 初期状態
        When アドレスが渡されると
        Then ユーザ部とホスト部が返される
