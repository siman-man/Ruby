# encoding: utf-8
require 'curses'

class Wireless
    include Curses
    def initialize
        @graph_x = 8
        @graph_y = 50
    end

    # This function get rssi value.
    def get_rssi
        # Get wireless information in MacOSX 
        a = `airport -I`
        data = a.split(/\n/)

        # Search RSSI value
        rssi = data[0].scan(/-\d\d/)[0].to_f
        return rssi
    end

    def create_graph_box(win, x, y)
        y.times do |y_pos|
            win.setpos(@graph_y-y_pos, @graph_x)
            win.addstr('|')
        end

        win.setpos(@graph_y, @graph_x)
        xscale = sprintf("*%s", "-" * x)
        win.addstr(xscale)
    end

    def create_rssi_meter(win, rssi)
        bar = '|' * (rssi.abs-20).round
        scale = sprintf("\t-20%s-100\n", " " * 76)
        meter = sprintf("\t[%-80s]", bar) 
        win.addstr(scale)
        win.addstr(meter)
    end

    def start_monitor
        begin
            init_screen
            win = Window.new(55, 200, 0, 0)
            1000.times do |count|
                win.clear
                rssi = get_rssi
                win.setpos(2,2)
                win.addstr("\tRssi value is #{rssi}\n\n")
                create_rssi_meter(win, rssi)
                win.setpos(0,0)
                create_graph_box(win, 80, 30)
                #win.box(?|,?-,?*)
                win.refresh
                sleep 1.0
            end
        ensure
            close_screen
        end
    end
end
