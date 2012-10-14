# encoding: utf-8
Feature: Q1で作成したクラスに機能を追加 

    kindは、インスタンス生成時に指定し、あとは参照のみ可とする
    mealメソッドは、文字列を渡すことでエサを与える
    feelingメソッドは、エサが与えられているときは"Good"を返し、エサがなくなると"Sad"
    を返す
    feelingメソッドは、エサを与えると一度だけ"Good"を返す

    Scenario: 問題1
        Given 初期状態
        When Dogクラスをインスタンス化した時
        Then p dog.kindを実行すると"Mongrel"が出力される
        When インスタンス化するときに"Papillon"を引数として与えると
        Then p dog.kindの出力が"Papillon"となる
        When kindに書き込みをしようとするとエラーが出力される
        When mealメソッドに文字列を渡すと
        Then エサが与えられた状態になる
        When エサが与えられている状態でfeelingメソッドを実行する
        Then "Good"が返される
        When エサがなくなっている場合にfeelingメソッドを実行する
        Then "Sad"が返される
