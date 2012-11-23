require 'spec_helper'

describe "test add tag id" do
  before(:each) do
    @p = Parse.new
  end

  it "should add def tag" do
    str = @p.add_def_id("test")
    str.should == '<span id="def">test</span>'
  end

  it "should add class tag" do
    str = @p.parse_line('class Test')
    str.should == '<span id="class">class</span> <span id="constant">Test</span>'
  end

  it "should add escape tag" do
    str = @p.parse_line('print "Hello Ruby!\n"') 
    str.should == 'print <span id="text">"Hello Ruby!<span id="escape">\n</span>"</span>'
  end

  it "should add instance tag" do
    str = @p.parse_line('print "Hello Ruby!\n"')
    str.should == 'print <span id="text">"Hello Ruby!<span id="escape">\n</span>"</span>'
  end

  it "should add while tag" do
    str = @p.parse_line('while i < 3 do')
    str.should == '<span id="while">while</span> i < <span id="number">3</span> <span id="do">do</span>'
  end

  it "should add include tag" do
    str = @p.parse_line('include Test')
    str.should == '<span id="include">include</span> <span id="constant">Test</span>'
  end

  it "should add module tag" do
    str = @p.parse_line('module Test')
    str.should == '<span id="module">module</span> <span id="constant">Test</span>'
  end

  it "should add accessor method" do
    str = @p.parse_line('def message=(message)')
    str.should == '<span id="def">def</span> <span id="def_name">message=</span>(message)'
  end

  it "should add accessor and symbol tag" do
    str = @p.parse_line('attr_accessor :message')
    str.should == '<span id="accessor">attr_accessor</span> <span id="symbol">:message</span>'

    str = @p.parse_line('apple: 4, :orange => 3')
    str.should == '<span id="symbol">apple</span>: <span id="number">4</span>, <span id="symbol">:orange</span> => <span id="number">3</span>'
  end

  it "should add comment tag" do
    str = @p.parse_line('# encoding: utf-8')
    str.should == '<span id="comment"># encoding: utf-8'
  end

  it "should add regexp tag" do
    str = @p.parse_line('word =~ /Ruby/')
    str.should == 'word =~ <span id="regexp">/</span><span id="pattern">Ruby</span><span id="regexp">/</span>'
  end
end


describe "test check sentence2words" do
  before(:each) do
    @p = Parse.new
  end

  it 'case "test line\n"' do
    array = ["test", " ", "line", "\n"]
    str = @p.sentence2words("test line\n")
    str.should == array
  end

  it 'case "puts "Hello Ruby!"' do
    array = ["puts", ' ', '"', "Hello", " ", "Ruby", '!', '"']
    str = @p.sentence2words('puts "Hello Ruby!"')
    str.should == array
  end

  it 'case "if 30 > 400"' do
    array = ["if", ' ', '30', ' ', '>', ' ', '400']
    str = @p.sentence2words('if 30 > 400')
    str.should == array
  end

  it 'case "array1 = []"' do
    array = ["array1", " ", "=", " ", "[", "]"]
    str = @p.sentence2words('array1 = []')
    str.should == array
  end

  it 'case "puts "1 + 1 = #{1+1}"' do
    array = ["puts", " ", '"', "1", " ", "+", " ", "1", " ", "=", " ", "\#{", "1", "+", "1", "}", '"']
    str = @p.sentence2words('puts "1 + 1 = #{1+1}"')
    str.should == array
  end

  it 'case "new_line += add_class_name_id(word)"' do
    array = ["new_line", " ", "+=", " ", "add_class_name_id", "(", "word", ")"]
    str = @p.sentence2words('new_line += add_class_name_id(word)')
    str.should == array
  end

  it 'case "@def_name_flag = false"' do
    array = ["@def_name_flag", " ", "=", " ", "false"]
    str = @p.sentence2words('@def_name_flag = false')
    str.should == array
  end

  it 'case "print "Hello Ruby!\n"' do
    array = ["print", ' ', '"', "Hello", " ", "Ruby", '!', '\n', '"']
    str = @p.sentence2words('print "Hello Ruby!\n"')
    str.should == array
  end

  it 'case "@end_count = 0"' do
    array = ["@end_count", ' ', '=', ' ', "0"]
    str = @p.sentence2words('@end_count = 0')
    str.should == array
  end

  it 'case "case test\n"' do
    array = ["case", " ", "test", "\n"]
    str = @p.sentence2words("case test\n")
    str.should == array
  end

  it 'case "include Test"' do
    array = ["include", " ", "Test"]
    str = @p.sentence2words("include Test")
    str.should == array
  end

  it 'case "def message=(message)"' do
    array = ["def", " ", "message=", "(", "message", ")"]
    str = @p.sentence2words("def message=(message)")
    str.should == array
  end

  it 'case "attr_accessor :message"' do
    array = ["attr_accessor", " ", ":message"]
    str = @p.sentence2words("attr_accessor :message")
    str.should == array
  end

  it 'case "hash = { apple: 3, :orange => 8, "banana" => 4 }"' do
    array = ["hash", " ", "=", " ", "{", " ", "apple:", " ", "3", ",", " ", ":orange", " ", "=>", " ", "8", ",", " ", "\"", "banana", "\"", " ", "=>", " ", "4", " ", "}"]
    str = @p.sentence2words("hash = { apple: 3, :orange => 8, \"banana\" => 4 }")
    str.should == array
  end
end

describe "test exec file convert to parsed code and compare this" do
  before(:all) do
    @sample_code = ['class', 'class2', 'tail', 'initialize', 'development', 'test_sample1',
    'include', 'accessor_before', 'accessor_after', 'ternary']
  end

  before(:each) do
    @p = Parse.new
    name = @sample_code.shift
    html_file = File.expand_path("test/html/#{name}.html", Dir::pwd)
    ruby_file = File.expand_path("test/ruby/#{name}.rb", Dir::pwd)
    @str, @code = '', ''

    File.open(html_file) do |file|
      file.readlines.each do |line|
        @str += line
      end
    end
    @code = @p.parse_code(ruby_file) 
  end

  it "should equal class.html and converted class.rb" do
    @str.should == @code
  end

  it "should equal class2.html and converted class2.rb" do
    @str.should == @code
  end

  it "should equal tail.html and converted tail.rb" do
    @str.should == @code
  end

  it "should equal initialize.html and converted initialize.rb" do
    @str.should == @code
  end

  it "should equal development.html and converted development.rb" do
    @str.should == @code
  end

  it "should equal test_sample1.html and converted test_sample1.rb" do
    @str.should == @code
  end

  it "should equal include.html and converted include.rb" do
    @str.should == @code
  end

  it "should equal accessor_before.html and converted accessor_before.rb" do
    @str.should == @code
  end

  it "should equal accessor_after.html and converted accessor_after.rb" do
    @str.should == @code
  end

  it "should equal ternary.html and converted ternary.rb" do
    @str.should == @code
  end
end
