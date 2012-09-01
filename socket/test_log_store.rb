require 'test/unit'
require './log_store'

class TestLogStore < Test::Unit::TestCase
    def test_log_store
        l = LogStore.new('client', 'localhost')
        today = Time.now.strftime("%Y/%m/%d")
        l.dir_check(today)
        l.log_file_open

        assert_equal true, l.check_year_dir
        assert_equal true, l.check_month_dir
        assert_equal true, l.check_day_dir
        assert_equal true, l.check_log_file
        l.dir_check("2013/03/02")
        assert_equal true, Dir.exist?("client_log/2013")
    end
end
