require 'pp'

mat = [[1,2,3],[4,5,6],[7,8,9]]

pp mat.transpose.map(&:reverse)  #=> 右回転
pp mat.reverse.map(&:reverse)    #=> 180度回転
pp mat.transpose.reverse         #=> 左回転
