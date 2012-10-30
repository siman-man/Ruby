require './parse'
require 'test/unit'

class TestParse < Test::Unit::TestCase
    def setup
        @p = Parse.new
    end

    def test_add_def_id
        assert_equal(false, @p.def_name_flag)

        str = @p.add_def_id("test")
        assert_equal(str, "<span id='def'>test</span>")
        assert_equal(true, @p.def_name_flag)
    end

    def test_parse_line
        str1 = @p.parse_line("def test")
        str2 = @p.parse_line("class Test")
        str3 = @p.parse_line("end")
        str4 = @p.parse_line("h = Hello.new")
        assert_equal(str1, "<span id='def'>def</span> <span id='func_name'>test</span>")
        assert_equal(str2, "<span id='class'>class</span> <span id='class_name'>Test</span>")
        assert_equal(str3, "<span id='end'>end</span>")
        assert_equal(str4, "h = <span id='class_name'>Hello</span>.new")
    end

    def test_parse_code
        #code = @p.parse_code("class.rb")
    end
end
