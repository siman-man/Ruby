require 'test/unit'
require './log_store'

class TestLogStore < Test::Unit::TestCase
    def test_client_log_store
        l = LogStore.new('client')
        today = Time.now.strftime("%Y/%m/%d")

        assert_equal false, l.check_year_dir
        assert_equal false, l.check_month_dir
        assert_equal false, l.check_day_dir
        assert_equal false, l.check_log_file('localhost.log')

        l.dir_check(today)
        l.log_file_open('localhost.log')

        assert_equal true, l.check_year_dir
        assert_equal true, l.check_month_dir
        assert_equal true, l.check_day_dir
        assert_equal true, l.check_log_file('localhost.log')

        l.dir_check("2013/03/02")
        assert_equal true, Dir.exist?("client_log/2013")
    end

    def test_server_log_store
        l = LogStore.new('server')
        today = Time.now.strftime("%Y/%m/%d")

        assert_equal false, l.check_year_dir
        assert_equal false, l.check_month_dir
        assert_equal false, l.check_day_dir
        assert_equal false, l.check_log_file('siman.log')

        l.dir_check(today)
        l.log_file_open('siman.log')

        assert_equal true, l.check_year_dir
        assert_equal true, l.check_month_dir
        assert_equal true, l.check_day_dir
        assert_equal true, l.check_log_file('siman.log')

        l.dir_check("2013/03/02")
        assert_equal true, Dir.exist?("server_log/2013")
    end
end
