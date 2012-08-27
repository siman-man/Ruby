# encoding: utf-8
require 'curses'
require './wireless'

class Monitor
    include Curses
    def initialize
        @graph_x = 8
        @graph_y = 50
    end

    def create_rssi_box(win, x, y)
        y.times do |y_pos|
            win.setpos(@graph_y-y_pos, @graph_x)
            win.addstr('|')
        end

        win.setpos(@graph_y, @graph_x)
        xscale = sprintf("*%s", "-" * x)
        win.addstr(xscale)
    end

    def create_channel_box(win, x, y)
    end

    def create_rssi_meter(win, rssi)
        bar = '|' * (rssi.abs-20).round
        scale = sprintf("\t-20%s-100\n", " " * 76)
        meter = sprintf("\t[%-80s]", bar) 
        win.addstr(scale)
        win.addstr(meter)
    end

    def create_ap_list(win, ap_list)
        ap_list.each_with_index do |ap, index|
            win.setpos(2*(index+1),2)
            win.addstr("\tSSID: #{ap[:SSID]}")
            win.addstr("\tRssi value is #{ap[:RSSI]}\n\n")
            create_rssi_meter(win, ap[:RSSI])
        end
    end

    def create_channel_list(win, ap_list)
    end

    def create_rssi_graph(win, ap_list)
    end

    def start_monitor
        begin
            ap_list = []
            init_screen
            wi_fi= Wireless.new
            win = Window.new(55, 200, 0, 0)
            1000.times do |count|
                win.clear
                ap_list = wi_fi.get_ap_info(wi_fi.ap_search)
                create_ap_list(win, ap_list)
                create_rssi_box(win, 80, 30)
                #win.box(?|,?-,?*)
                win.refresh
                sleep 1.0
            end
        ensure
            close_screen
        end
    end
end
