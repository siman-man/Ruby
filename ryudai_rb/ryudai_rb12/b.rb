# 高橋国の数字の序列
$num_list = gets.chomp.split(' ')
p $num_list

def convert(num)
  puts "高橋 : #{num.split('').join('')}, 現代 : #{num.split('').map{|elem| $num_list.find_index(elem)}.join('').to_i}"
  num.split('').map{|elem| $num_list.find_index(elem)}.join('').to_i
end

# 文字列の個数
n = gets.chomp.to_i

number_list = []

n.times do 
  # number_listにどんどん値を足していく
  number_list << gets.chomp
end

answers = []

puts number_list.sort_by{|number| convert(number) }


#
# 40分に解答編
#
# ヒント: 
# 高橋国の数字を現代の数値に置き換えることができれば。
#
# ヒント:
# 1桁よりは2桁のほうがどう転んでも大きい
#

#
# group_by : ブロック文{}のなかの値によって配列の要素をグループ分けする
#
# num.size => 文字列の長によってグループ分けを行なっている
#=> {1=>["1", "2", "3", "4", "5", "6", "7", "8", "9"], 2=>["10"]}
#

# 
# find_index : 引数で渡した配列の場所の値を返す
#
# [1,2,3,4,5,10,11].find_index(1) #=> 0
# [1,2,3,4,5,10,11].find_index(5) #=> 4
# [1,2,3,4,5,10,11].find_index(11) #=> 6
#

#
# sort_by : ブロック文の{}の中の値によってソートを行う(昇順)
#
# ["siman", "abc", "simanman", "test"].sort_by{|str| str.size}
# => ["abc", "test", "siman", "simanman"]
#
# 文字サイズが小さい順にソートされていることがわかる。
#
#

