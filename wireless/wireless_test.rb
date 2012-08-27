require 'test/unit'
require './wireless'

class WirelessTest < Test::Unit::TestCase
    def test_get_rssi
        w = Wireless.new
        assert_equal Float, w.get_rssi.class
    end
end
