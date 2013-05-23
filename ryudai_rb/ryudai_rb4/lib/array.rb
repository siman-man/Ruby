array = (1..10).to_a

p array

array.delete_if{|n| n.odd? }

p array
