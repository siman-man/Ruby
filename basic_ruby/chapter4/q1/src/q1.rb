# encoding: utf-8

str =<<-EOS
    数値5.5の場合の結果
    round(5.5) = #{(5.5).round} 
    ceil(5.5) = #{(5.5).ceil} 
    floor(5.5) = #{(5.5).floor} 
EOS

puts str
