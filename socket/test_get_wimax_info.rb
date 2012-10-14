require 'test/unit'
require './get_wimax_info.rb'

class TestGetWimaxInfo < Test::Unit::TestCase

    def setup
        @g = GetWimaxInfo.new
    end

    def test_get_info
        assert_equal nil, @g.get_info(" ")

        assert_equal "ERROR: Invalid RSSI value is included ", @g.get_info("Received Signal Strength")
        assert_equal Float, @g.get_info("Received Signal Strength-63.0 dBm").class
        assert_equal -63.0, @g.get_info("Received Signal Strength-63.0 dBm")
        assert_equal -63.3, @g.get_info("Received Signal Strength-63.33 dBm")
        assert_equal -3.3, @g.get_info("Received Signal Strength-3.3 dBm")
        assert_equal "ERROR: Invalid RSSI value is included -630.", @g.get_info("Received Signal Strength-630.3 dBm")

        assert_equal 34.7, @g.get_info("SNR34.7 dB")
        assert_equal "ERROR: Invalid SNR value is included 3", @g.get_info("SNR3")
        assert_equal Float, @g.get_info("SNR34.7 dB").class
        assert_equal 50.7, @g.get_info("SNR50.7 dB")
        assert_equal 0.7, @g.get_info("SNR0.7 dB")

        assert_equal "64QAM 2/3", @g.get_info("Modulation64QAM 2/3")
    end 

    def test_get_wimax_info
        log = @g.get_wimax_info("18:32:45")
        assert_equal "18:32:45,-63.00,34.70,64QAM 2/3", log
    end

    def test_get_host_name
        host = @g.get_host_name
        assert_equal "siman", host
    end

    def test_get_ip
        ip = @g.get_ip
        assert_equal "133.13.52.183", ip
    end
end
