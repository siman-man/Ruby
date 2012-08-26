require 'curses'

module Screen
    def self.clear
        print "\e[H\e[2J"
    end
end

rssi_data = Hash.new(0)
Curses::init_screen
1000.times do |count|
    Curses::setpos(0,0)
    a = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I`
    data = a.split(/\n/)
    rssi = data[0].scan(/-\d\d/)[0]
    bar = "#" * count
    printf("Rssi value is %s\n", rssi)
    printf("|%-50s| %d", bar, count)
    sleep 1.0
end
Curses::close_screen
