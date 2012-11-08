# encoding: utf-8
require 'test/unit'
require 'pp'
require './file_manager'

class TestFileManager < Test::Unit::TestCase
    def setup
        @fm = FileManager.new
    end

    def test_create_directory
        dirname = 'siman'
        @fm.create_directory(dirname)
        assert_equal true, File.exists?(dirname)
        `rm -rf #{dirname}`
    end

    def test_show_file_list
        @fm.show_file_list('data')
    end

    def test_get_file_stat
        @fm.get_file_stat('file_manager.rb')
    end

    def teardown
    end
end


