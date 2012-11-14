require './parse'
require 'test/unit'

class TestParse < Test::Unit::TestCase
  def setup
    @p = Parse.new
  end


  def test_add_def_id
    assert_equal(false, @p.def_name_flag)

    str = @p.add_def_id("test")
    assert_equal(str, '<span id="def">test</span>')
    assert_equal(true, @p.def_name_flag)
  end

  def test_def_end
    str1 = @p.parse_line("def test")
    @p.end_count += 1
    str2 = @p.parse_line("end")
    assert_equal(str1, '<span id="def">def</span> <span id="func_name">test</span>')
    assert_equal(str2, '<span id="def_end">end</span>')
  end

  def test_escape_id
    str = @p.parse_line('print "Hello Ruby!\n"')
    assert_equal(str, 'print <span id="text">"Hello Ruby!<span id="escape">\n</span>"</span>')
  end

  def test_instance_id
    str = @p.parse_line('@end_count = 0')
    assert_equal(str, '<span id="instance">@end_count</span> = <span id="number">0</span>')
  end

  def test_parse_line
    str2 = @p.parse_line("class Test")
    @p.end_count += 1
    str3 = @p.parse_line("end")
    str4 = @p.parse_line("h = Hello.new")
    str5 = @p.parse_line('puts "Hello Ruby!"')
    str6 = @p.parse_line('if 3 > 4')
    str7 = @p.parse_line('if 30 > 400')
    str8 = @p.parse_line('case test')
    str9 = @p.parse_line('when 3')
    str10 = @p.parse_line('print_hello(3333)')
    str11 = @p.parse_line('print_hello(11, 22)')
    str12 = @p.parse_line('do')
    str13 = @p.parse_line('while i < 3 do')
    str14 = @p.parse_line('for i in 0..2 do')
    str15 = @p.parse_line('puts "in the hell"')
    str16 = @p.parse_line('until i > 3 do')
    str17 = @p.parse_line('loop do')
    str18 = @p.parse_line('break;')
    str19 = @p.parse_line('array1 = Array.new(3)')
    str20 = @p.parse_line('puts "1 + 1 = #{1+1}"')
    str21 = @p.parse_line("# encoding: utf-8\n")
    str22 = @p.parse_line('message =~ /Ruby/')


    assert_equal(str2, '<span id="class">class</span> <span id="class_name">Test</span>')
    assert_equal(str3, '<span id="class_end">end</span>')
    assert_equal(str4, 'h = <span id="class_name">Hello</span>.new')
    assert_equal(str5, 'puts <span id="text">"Hello Ruby!"</span>')
    assert_equal(str6, '<span id="if">if</span> <span id="number">3</span> > <span id="number">4</span>')
    assert_equal(str7, '<span id="if">if</span> <span id="number">30</span> > <span id="number">400</span>')
    assert_equal(str8, '<span id="case">case</span> test') 
    assert_equal(str9, '<span id="when">when</span> <span id="number">3</span>') 
    assert_equal(str10, 'print_hello(<span id="number">3333</span>)')
    assert_equal(str11, 'print_hello(<span id="number">11</span>, <span id="number">22</span>)')
    assert_equal(str12, '<span id="do">do</span>')
    assert_equal(str13, '<span id="while">while</span> i < <span id="number">3</span> <span id="do">do</span>')
    assert_equal(str14, '<span id="for">for</span> i <span id="in">in</span> <span id="number">0</span>..<span id="number">2</span> <span id="do">do</span>')
    assert_equal(str15, 'puts <span id="text">"in the hell"</span>')
    assert_equal(str16, '<span id="until">until</span> i > <span id="number">3</span> <span id="do">do</span>')
    assert_equal(str17, '<span id="loop">loop</span> <span id="do">do</span>')
    assert_equal(str18, '<span id="break">break</span>;') 
    assert_equal(str19, 'array1 = <span id="class_name">Array</span>.new(<span id="number">3</span>)') 
    assert_equal(str20, 'puts <span id="text">"1 + 1 = <span id="formula">#{</span>1+1<span id="formula">}</span>"</span>')
    assert_equal(str21, "<span id=\"comment\"># encoding: utf-8</span>\n")
    assert_equal(str22, 'message =~ <span id="regexp">/</span><span id="pattern">Ruby</span><span id="regexp">/</span>')
  end

  def test_block_parse
    str23 = @p.parse_line('File.open(\'file.rb\', \'r\') do |file|')
    assert_equal(str23, '<span id="class_name">File</span>.open(<span id="all_text">\'file.rb\'</span>, <span id="all_text">\'r\'</span>) <span id="do">do</span> |<span id="block_arg">file</span>|')
  end

  def test_parse_code
    str = ''
    file = File.open("after_class.html")

    file.readlines.each do |line|
      str += line
    end
  end

  def test_end_count
    file = File.open("class.rb")
    count = @p.count_end_num(file)
    file.close
    assert_equal(count, 3)

    file = File.open('class2.rb')
    count = @p.count_end_num(file)
    file.close
    assert_equal(count, 2)
  end

  def test_end_count
    file = File.open('class2.rb')
    count = @p.count_end_num(file)
    file.close
    assert_equal(count, 2)
  end

  def test_sentence2words
    array1 = ["test", " ", "line", "\n"]
    array2 = ["puts", ' ', '"', "Hello", " ", "Ruby", '!', '"']
    array3 = ["if", ' ', '30', ' ', '>', ' ', '400']
    array4 = ["array1", " ", "=", " ", "[", "]"]
    array5 = ["puts", " ", '"', "1", " ", "+", " ", "1", " ", "=", " ", "\#{", "1", "+", "1", "}", '"']
    array6 = ["new_line", " ", "+=", " ", "add_class_name_id", "(", "word", ")"]
    array7 = ["@def_name_flag", " ", "=", " ", "false"]
    array8 = ["print", ' ', '"', "Hello", " ", "Ruby", '!', '\n', '"']
    array9 = ["@end_count", ' ', '=', ' ', "0"]
    array10 = ["case", " ", "test", "\n"]
    str1 = @p.sentence2words("test line\n")
    str2 = @p.sentence2words('puts "Hello Ruby!"')
    str3 = @p.sentence2words('if 30 > 400')
    str4 = @p.sentence2words('array1 = []')
    str5 = @p.sentence2words('puts "1 + 1 = #{1+1}"')
    str6 = @p.sentence2words('new_line += add_class_name_id(word)')
    str7 = @p.sentence2words('@def_name_flag = false')
    str8 = @p.sentence2words('print "Hello Ruby!\n"')
    str9 = @p.sentence2words('@end_count = 0')
    str10 = @p.sentence2words("case test\n")
    assert_equal(str1, array1) 
    assert_equal(str2, array2) 
    assert_equal(str3, array3)
    assert_equal(str4, array4)
    assert_equal(str5, array5)
    assert_equal(str6, array6)
    assert_equal(str7, array7)
    assert_equal(str8, array8)
    assert_equal(str9, array9)
    assert_equal(str10, array10)
  end

  def test_parse_code
    str = ''
    file = File.open("after_class.html")

    file.readlines.each do |line|
      str += line
    end
    puts ''
    code = @p.parse_code('class.rb')
    assert_equal(str, code)
  end
end
