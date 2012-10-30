require './parse'
require 'test/unit'

class TestParse < Test::Unit::TestCase
    def setup
        @p = Parse.new
    end

    def test_parse_line
        str1 = @p.parse_line("def test")
        str2 = @p.parse_line("class test")
        str3 = @p.parse_line("end")
        assert_equal(str1, "<span id='def'>def</span> test")
        assert_equal(str2, "<span id='class'>class</span> test")
        assert_equal(str3, "<span id='end'>end</span>")
    end
end
