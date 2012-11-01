require 'strscan'

class Parse
  attr_reader :def_name_flag, :class_name_flag

  def initialize
    @new_code = ''
    @def_name_flag = false
    @class_name_flag = false
    @text_flag = false
    @end_list = []
  end

  def add_def_id(word)
    @end_list.push('def')
    @def_name_flag = true
    "<span id='def'>" + word + "</span>"
  end

  def add_def_name_id(word)
    @def_name_flag = false
    "<span id='func_name'>" + word + "</span>"
  end

  def add_class_id(word)
    @end_list.push('class')
    @class_name_flag = true
    "<span id='class'>" + word + "</span>"
  end

  def add_class_name_id(word)
    @class_name_flag = false
    "<span id='class_name'>" + word + "</span>"
  end

  def add_module_name_id(word)
    "<span id='module_name'>" + word + "</span>"
  end

  def add_end_id(word)
    end_type = @end_list.pop
    case end_type
    when 'def'
      "<span id='def_end'>" + word + "</span>"
    when 'class'
      "<span id='class_end'>" + word + "</span>"
    when 'module'
      "<span id='module_end'>" + word + "</span>"
    else
      "<span id='end'>" + word + "</span>"
    end
  end

  def add_if_id(word)
    "<span id='if'>" + word + "</span>"
  end

  def add_else_id(word)
    "<span id='else'>" + word + "</span>"
  end

  def add_case_id(word)
    "<span id='case'>" + word + "</span>"
  end

  def add_when_id(word)
    "<span id='when'>" + word + "</span>"
  end

  def add_do_id(word)
    "<span id='do'>" + word + "</span>"
  end

  def add_while_id(word)
    "<span id='while'>" + word + "</span>"
  end

  def add_for_id(word)
    "<span id='for'>" + word + "</span>"
  end

  def add_until_id(word)
    "<span id='until'>" + word + "</span>"
  end

  def add_loop_id(word)
    "<span id='loop'>" + word + "</span>"
  end

  def add_break_id(word)
    "<span id='break'>" + word + "</span>"
  end

  def add_in_id(word)
    if @text_flag
      word
    else
      "<span id='in'>" + word +"</span>"
    end
  end

  def add_number_id(ch)
    "<span id='number'>" + ch + "</span>"
  end


  def add_text_id(ch)
    if @text_flag 
      @text_flag = false
      ch + "</span>"
    else
      @text_flag = true
      "<span id='text'>" + ch
    end
  end

  def upper?(str)
    /[A-Z]/ =~ str
  end

  def sentence2words(text)
    scanner = StringScanner.new(text)
    words = []
    until scanner.eos?
      words.push scanner.scan(/\w+|\W/)
    end
    return words
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
        else
          word.each_char do |ch|
            if(ch =~ /"|'/)
              new_line += add_text_id(ch)
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

