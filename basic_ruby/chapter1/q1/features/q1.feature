Feature: EXOR関数の作成

    2つの引数が渡された時に
    TRUEかFALSEを返却したい。

  
  Scenario: ２つの引数を渡すと、TRUEかFALSEが返される
    Given EXORの状態
    When TRUE,TRUEと引数が渡されると
    Then FALSEが返される


