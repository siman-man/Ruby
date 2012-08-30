# encoding: utf-8
require 'curses'
require './wireless'

class Monitor
    include Curses

    attr_reader :graph_width, :graph_height, :graph_x, :graph_y
    attr_reader :rssi_history

    def initialize
        @ap_list = {}
        @graph_x = 8
        @graph_y = 50
        @graph_width = 80
        @graph_height = 25
        @graph_scale_y = 80 / @graph_height.to_f
        @channel_x = 100
        @channel_y = 50
        @channel_width = 80
        @channel_height = 25
        @rssi_history = Array.new(@graph_height){Array.new(@graph_width/2,0)}
    end

    def create_rssi_box(win, x, y)
        1.upto(y) do |y_pos|
            win.setpos(@graph_y-y_pos, @graph_x)
            win.addstr('|')
        end

        win.setpos(@graph_y, @graph_x)
        xscale = sprintf("*%s", "-" * x)
        win.addstr(xscale)
    end

    def create_rssi_scale(win)
        win.setpos(@graph_y, 2)
        win.addstr("-100")
        win.setpos(@graph_y-@graph_height, 2)
        win.addstr(" -20")
    end

    def create_channel_box(win, x, y)
        1.upto(y) do |y_pos|
            win.setpos(@channel_y-y_pos, @channel_x)
            win.addstr('|')
        end

        win.setpos(@channel_y, @channel_x)
        xscale = sprintf("*%s", "-" * x)
        win.addstr(xscale)
    end

    def create_rssi_meter(win, rssi)
        bar = '|' * (100-rssi.abs).round
        meter = sprintf("\t[%-80s]", bar) 
        win.addstr(meter)
    end

    def array2hash(array)
        hash = {}
        array.each do |array|
            hash[array[0]] = array[1]
        end
        return hash
    end

    def create_ap_list(win, ap_list)
        index = 0
        win.setpos(0,2)
        ap_list = array2hash(ap_list.sort_by{|bssid, ap| -ap[:RSSI]})
        menu = sprintf("%32s\t%6s\t%8s\t-100 %s-60 %s-20\n", "SSID", "RSSI", "CHANNEL", " " * 36, " " * 36) 
        win.addstr(menu)
        ap_list.each_pair do |bssid, ap|
            win.setpos(index+1,2)
            msg = sprintf("%32s\t%4.2f\t%8s", ap[:SSID], ap[:RSSI], ap[:CHANNEL])
            win.addstr(msg)
            create_rssi_meter(win, ap[:RSSI])
            index += 1
        end
    end

    def create_channel_list(win, ap_list)
    end

    def rssi_graph_renew
        @rssi_history.each do |array|
            array.shift
        end
    end

    def create_rssi_graph(win, ap_list)
        index = 0
        rssi_graph_renew

        ap_list.each_pair do |bssid, ap|
            next if index > 0
            h = ((ap[:RSSI].abs-20) / @graph_scale_y).truncate
            if(@rssi_history[h].size != @graph_width/2)
                @rssi_history[h] << 1    
            end
            index += 1
        end
        @rssi_history.each do |array|
            if(array.size != @graph_width/2)
                array << 0
            end
        end
        @rssi_history.each_with_index do |array, y|
            array.each_with_index do |value, x|
                if(value != 0)
                    win.setpos(@graph_y - @graph_height + y, @graph_x + (x+1))
                    win.addstr("#")
                end
            end
        end
        setpos(0,0)
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
                create_rssi_box(win, @graph_width, @graph_height)
                create_rssi_scale(win)
                create_rssi_graph(win, ap_list)
                create_channel_box(win, @channel_width, @channel_height)
                win.refresh
                sleep 1.0
            end
        ensure
            close_screen
        end
    end
end
