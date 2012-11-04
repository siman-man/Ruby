require 'strscan'

class Parse
  attr_reader :def_name_flag, :class_name_flag

  def initialize
    @new_code = ''
    @def_name_flag = false
    @class_name_flag = false
    @text_flag = false
    @formula_flag = false
    @comment_flag = false
    @end_list = []

    @tag_id_list = ['if', 'else', 'when', 'case', 'number', 'while', 'do',
                    'for', 'until', 'loop', 'break', 'formula', 'in']
    @tag_id_list.each do |word|
      Parse.define_id_tag(word) 
    end
  end

  def add_def_id(word)
    @end_list.push('def')
    @def_name_flag = true
    '<span id="def">' + word + '</span>'
  end

  def add_def_name_id(word)
    @def_name_flag = false
    '<span id="func_name">' + word + '</span>'
  end

  def add_class_id(word)
    @end_list.push('class')
    @class_name_flag = true
    '<span id="class">' + word + '</span>'
  end

  def add_class_name_id(word)
    @class_name_flag = false
    '<span id="class_name">' + word + '</span>'
  end

  def add_module_name_id(word)
    '<span id="module_name">' + word + '</span>'
  end

  def add_end_id(word)
    end_type = @end_list.pop
    case end_type
    when 'def'
      '<span id="def_end">' + word + '</span>'
    when 'class'
      '<span id="class_end">' + word + '</span>'
    when 'module'
      "<span id='module_end'>" + word + "</span>"
    else
      "<span id='end'>" + word + "</span>"
    end
  end

  def add_text_id(ch)
    if @text_flag 
      @text_flag = false
      ch + "</span>"
    else
      @text_flag = true
      '<span id="text">' + ch
    end
  end

  def add_comment_id(ch)
    if @comment_flag 
      '</span>' + ch
    else
      @comment_flag = true
      '<span id="comment">' + ch 
    end
  end

  def upper?(str)
    /[A-Z]/ =~ str
  end

  def sentence2words(text)
    scanner = StringScanner.new(text)
    words = []
    until scanner.eos?
      words.push scanner.scan(/(\w|\d)+|\s+|\#{|\W|\S+/)
    end
    return words
  end

  def self.define_id_tag(name)
    define_method :"add_#{name}_id" do |word|
      if @formula_flag
        "<span id=\"#{name}\">" + word + "</span>"
      elsif @text_flag || @comment_flag
        word
      else
        "<span id=\"#{name}\">" + word + "</span>"
      end
    end
  end

  def parse_line(text)
    new_line = ''
    result = sentence2words(text)

    result.each do |word|
      case word
      when 'def'
        new_line += add_def_id(word)
      when 'class'
        new_line += add_class_id(word)
      when 'end'
        new_line += add_end_id(word)
      when '"'
        new_line += add_text_id(word)
      when 'if'
        new_line += add_if_id(word)
      when 'else'
        new_line += add_else_id(word)
      when 'case'
        new_line += add_case_id(word)
      when 'when'
        new_line += add_when_id(word)
      when 'do'
        new_line += add_do_id(word)
      when 'for'
        new_line += add_for_id(word)
      when 'while'
        new_line += add_while_id(word)
      when 'in'
        new_line += add_in_id(word)
      when 'until'
        new_line += add_until_id(word)
      when 'loop'
        new_line += add_loop_id(word)
      when 'break'
        new_line += add_break_id(word)
      else
        if @def_name_flag && /\w+/ =~ word
          new_line += add_def_name_id(word) 
        elsif @class_name_flag && /\w+/ =~ word
          new_line += add_class_name_id(word) unless @text_flag
        elsif upper?(word[0])
          if upper?(word[1])
            new_lien += add_module_name_id(word) unless @text_flag
            new_lien += word if @text_flag
          else 
            new_line += add_class_name_id(word) unless @text_flag
            new_line += word if @text_flag
          end
        elsif word =~ /^[0-9]+/
          new_line += add_number_id(word) unless @text_flag
          new_line += word if @text_flag
        elsif word =~ /\#{/
          @formula_flag = true
          new_line += add_formula_id(word) if @text_flag
          new_line += word unless @text_flag
        else
          word.each_char do |ch|
            if(ch =~ /"|'/)
              new_line += add_text_id(ch)
            elsif(ch =~ /}/)
              new_line += add_formula_id(ch) if @formula_flag
              new_line += ch unless @formula_flag
              @formula_flag = false
            elsif(ch =~ /#/)
              new_line += add_comment_id(ch) unless (@comment_flag || @text_flag)
            elsif(ch =~ /\n/)
              if @comment_flag
                new_line += add_comment_id(ch)
                @comment_flag = false
              else
                new_line += ch
              end
            else
              new_line += ch
            end
          end
        end
      end
    end

    return new_line
  end

  def parse_code(filename)
    file = File.open(filename) 

    file.readlines.each do |text|
      @new_code += parse_line(text)
    end
    file.close
    puts @new_code
    return @new_code
  end
end
