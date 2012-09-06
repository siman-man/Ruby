require 'test/unit'
require './rssi_collect'

class TestRssiCollect < Test::Unit::TestCase
    def test_string_time2seconds
        c = CollectRSSI.new
        assert_equal Fixnum, c.string_time2seconds("12:34:56").class
        assert_equal 3600, c.string_time2seconds("01:00:00")
        assert_equal 0, c.string_time2seconds("00:00:00")
        assert_equal 86400, c.string_time2seconds("24:00:00")
        assert_equal "Invalid string time 24:00:01", c.string_time2seconds("24:00:01")
        assert_equal "Invalid string time aaaa", c.string_time2seconds("aaaa")
    end

    def test_seconds2string_time
        c = CollectRSSI.new
        assert_equal String, c.seconds2string_time(30).class
        assert_equal "01:00:00", c.seconds2string_time(3600)
        assert_equal "00:00:00", c.seconds2string_time(0)
        assert_equal "24:00:00", c.seconds2string_time(86400)
        assert_equal "01:00:00", c.seconds2string_time(3600.5)
        assert_equal "Invalid seconds 86401", c.seconds2string_time(86401)
        assert_equal "Invalid seconds -1", c.seconds2string_time(-1)
    end

    def test_get_current_time
        c = CollectRSSI.new
        assert_equal String, c.get_current_time.class
        assert_equal "00:00:00", c.get_current_time
    end

    def test_increment_time
        c = CollectRSSI.new
        c.increment_time
        assert_equal "00:00:01", c.get_current_time
    end

    def test_file_contents_check
        c = CollectRSSI.new
        correct_data = ["12:34:56", "-56.4", "32.4"]
        false_data = ["122131", "-54.4", "43.1"]
        
        assert_equal false, c.check_file_contents("test")
        assert_equal true, c.check_file_contents(correct_data)
        assert_equal false, c.check_file_contents(false_data)
    end

    def test_calc_array_average
        c = CollectRSSI.new
        rssi_list = [-70.0, -64.0, -76.0]
        snr_list = [33.0, 24.0, 33.0]
        assert_equal -70.0, c.calc_array_average(rssi_list)
        assert_equal 30.0, c.calc_array_average(snr_list)
    end

    def test_collect_rssi
        c = CollectRSSI.new
        c.collect_rssi("test.log")
    end
end
