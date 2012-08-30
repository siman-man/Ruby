require 'test/unit'
require './wireless'

class WirelessTest < Test::Unit::TestCase
    def test_get_ap_info
        w = Wireless.new
        ap_table = w.ap_search
        ap_list = w.get_ap_info(ap_table)
        ap_list.each_pair do |bssid, ap|
            assert_equal String, ap[:SSID].class
            assert_equal Float, ap[:RSSI].class
            assert ap[:RSSI] < -10, "#{ap[:SSID]}, #{ap[:RSSI]} is rather than -20"
            assert ap[:RSSI] > -100, "#{ap[:SSID]}, #{ap[:RSSI]} is less than -100"
            assert_equal String, ap[:CHANNEL].class
        end
        ap_table = nil
        ap_list = w.get_ap_info(ap_table)
        assert_equal 0, ap_list
    end
end
