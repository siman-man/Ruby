rssi_history = Array.new(25,Array.new(40, 0))

p rssi_history

rssi_history.each do |array|
    array.shift
end

p rssi_history
