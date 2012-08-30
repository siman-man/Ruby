require 'test/unit'
require './monitor'
require './wireless'

class MonitorTest < Test::Unit::TestCase
    def test_initialize
        m = Monitor.new
        m.rssi_history.each do |array|
            assert_equal(array.size, 40)
            assert_equal(array.size, m.graph_width/2)
        end
    end

    def test_rssi_graph_renew
        w = Wireless.new
        m = Monitor.new
        ap_table = w.ap_search
        ap_list = w.get_ap_info(ap_table)

        m.rssi_history.each do |array|
            assert_equal(array.size, m.graph_width/2) 
        end

        m.rssi_graph_renew()

        m.rssi_history.each_with_index do |array, index|
            assert_equal(array.size, m.graph_width/2 - 1, "#{array} #{m.rssi_history}")
        end
    end
end
