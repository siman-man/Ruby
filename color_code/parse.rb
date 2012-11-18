require 'strscan'

class Parse
  attr_reader :def_name_flag, :class_name_flag
  attr_accessor :end_count

  def initialize
    @new_code = ''
    @end_count = 0
    @def_name_flag = false
    @class_name_flag = false
    @text_flag = false
    @all_text_flag = false
    @formula_flag = false
    @formula_text = ''
    @comment_flag = false
    @regexp_flag = false
    @block_arg_flag = false
    @end_list = []

    @tag_id_list = ['else', 'when', 'case', 'number', 'while',
      'for', 'loop', 'break', 'in', 
      'then', 'elsif', 'return', 'true', 'false',
      'instance']
    @tag_id_list.each do |word|
      Parse.define_id_tag(word) 
    end
  end


  def add_if_id(word, index)
    if @text_flag || @comment_flag || @all_text_flag
      word
    elsif index <= 1
      @end_list.push('if')
      '<span id="if">' + word + '</span>'
    else
      '<span id="if">' + word + '</span>'
    end
  end

  def add_unless_id(word, index)
    if @text_flag || @comment_flag || @all_text_flag
      word
    elsif index <= 1
      @end_list.push('unless')
      '<span id="unless">' + word + '</span>'
    else
      '<span id="unless">' + word + '</span>'
    end
  end


  def add_case_id(word)
    if @text_flag || @comment_flag || @all_text_flag
      word
    else
      @end_list.push('case')
      '<span id="case">' + word + '</span>'
    end
  end

  def add_until_id(word)
    if @text_flag || @comment_flag || @all_text_flag
      word
    else
      @end_list.push('until')
      '<span id="until">' + word + '</span>'
    end
  end

  def add_formula_id(word)
    if @formula_flag
      if @all_text_flag
        @all_text_flag = false
        @formula_text = 'all_text' 
      elsif @text_flag
        @text_flag = false
        @formula_text = 'text' 
      end
      '<span id="formula">' + word + '</span></span>'
    elsif @comment_flag
      word
    elsif @formula_text == 'all_text'
      @formula_text = ''
      @all_text_flag = true
      '<span id="formula">' + word + '</span><span id="all_text">'
    elsif @formula_text == 'text'
      @formula_text = ''
      @text_flag = true
      '<span id="formula">' + word + '</span><span id="text">'
    else
      word
    end
  end


  def add_def_id(word)
    if @text_flag || @comment_flag || @all_text_flag
      word
    else
      @def_name_flag = true
      @end_list.push('def')
      '<span id="def">' + word + '</span>'
    end
  end

  def add_escape_id(word)
    '<span id="escape">' + word + '</span>'
  end

  def add_keyword_id(ch)
    '<span id="keyword">' + ch + '</span>'
  end

  def add_do_id(word)
    if @text_flag || @comment_flag
      word
    else
      @end_list.push('do')
      '<span id="do">' + word + '</span>'
    end
  end

  def add_def_name_id(word)
    @def_name_flag = false
    '<span id="func_name">' + word + '</span>'
  end

  def add_class_id(word)
    if @text_flag || @comment_flag || @all_text_flag
      word
    else
      @class_name_flag = true
      @end_list.push('class')
      '<span id="class">' + word + '</span>'
    end
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
      '<span id="module_end">' + word + '</span>'
    else
      '<span id="end">' + word + '</span>'
    end
  end

  def add_regexp_id(ch)
    if @regexp_flag
      '</span><span id="regexp">' + ch + '</span>'
    else 
      '<span id="regexp">' + ch + '</span><span id="pattern">'
    end
  end

  def add_text_id(ch)
    if @all_text_flag || @regexp_flag
      ch
    elsif @text_flag 
      @text_flag = false
      ch + '</span>'
    else
      @text_flag = true
      '<span id="text">' + ch
    end
  end

  def add_all_text_id(ch)
    if @text_flag || @regexp_flag 
      ch
    elsif @all_text_flag
      @all_text_flag = false
      ch + '</span>'
    else
      @all_text_flag = true
      '<span id="all_text">' + ch
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

  def add_block_arg_id(ch)
    if @text_flag || @comment_flag || @all_text_flag || @regexp_flag 
      ch
    elsif @block_arg_flag 
      @block_arg_flag = false
      '</span>' + ch 
    else
      @block_arg_flag = true
      ch + '<span id="block_arg">'
    end
  end

  def upper?(str)
    /[A-Z]/ =~ str
  end

  def sentence2words(text)
    scanner = StringScanner.new(text)
    words = []
    until scanner.eos?
      words.push scanner.scan(/(@|\w|\d|_)+|\s+|\#{|(\+|\-|\*|\/|=)+|\\([a-z]|[A-Z]|("|')|\/){1}|\W|\S+/)
    end
    return words
  end

  def self.define_id_tag(name)
    define_method :"add_#{name}_id" do |word|
      if @formula_flag
        "<span id=\"#{name}\">" + word + '</span>'
      elsif @text_flag || @comment_flag || @all_text_flag
        word
      else
        "<span id=\"#{name}\">" + word + '</span>'
      end
    end
  end

  def parse_line(text)
    new_line = ''
    result = sentence2words(text)

    result.each_with_index do |word, index|
      if @tag_id_list.include?(word)
        eval("new_line += add_#{word}_id(word)")
        next
      end
      case word
      when 'def'
        new_line += add_def_id(word) 
      when 'class'
        new_line += add_class_id(word) 
      when 'end'
        unless @text_flag || @all_text_flag || @comment_flag
          new_line += add_end_id(word)
        else
          new_line += word
        end
      when 'if'
        new_line += add_if_id(word, index)
      when 'unless'
        new_line += add_unless_id(word, index)
      when 'do'
        new_line += add_do_id(word)
      when 'until'
        new_line += add_until_id(word)
      else
        if word =~ /^@(\d|\w|\_)+/
          new_line += add_instance_id(word) unless @text_flag || @regexp_flag || @all_text_flag || @comment_flag
        elsif @def_name_flag && /\w+/ =~ word
          new_line += add_def_name_id(word) 
        elsif @class_name_flag && /\w+/ =~ word
          new_line += add_class_name_id(word) unless @text_flag || @regexp_flag || @all_text_flag || @comment_flag
        elsif upper?(word[0])
          if !@text_flag && !@regexp_flag && !@all_text_flag
            new_line += add_class_name_id(word)
          elsif @regexp_flag
            new_line += word
          else
            new_line += word
          end
        elsif word =~ /^[0-9]+/
          new_line += add_number_id(word) unless @text_flag || @regexp_flag || @all_text_flag || @comment_flag
          new_line += word if @text_flag || @regexp_flag || @all_text_flag || @comment_flag
        elsif word =~ /\#{/
          unless @regexp_flag 
            @formula_flag = true
            new_line += add_formula_id(word) 
          else
            new_line += word
          end
        elsif word =~ /\\n/
          new_line += add_escape_id(word) if @text_flag
        elsif word =~ /\\(\w|\W){1}/
          new_line += word
        elsif word =~ /\\\//
          new_line += word
        elsif word =~ /(\|\||\&\&){1}/
          new_line += word
        else
          word.each_char do |ch|
            if ch =~ /"/
              new_line += add_text_id(ch)
            elsif ch =~ /'/
              new_line += add_all_text_id(ch)
            elsif ch =~ /}/
              @formula_flag = false
              new_line += add_formula_id(ch)
            elsif ch =~ /#/
              new_line += add_comment_id(ch) unless @comment_flag || @text_flag || @all_text_flag || @regexp_flag
            elsif ch =~ /\n/
              if @comment_flag
                new_line += add_comment_id(ch)
                @comment_flag = false
              else
                new_line += ch 
              end
            elsif ch =~ /\//
              unless @comment_flag || @text_flag || @all_text_flag
                new_line += add_regexp_id(ch)
                @regexp_flag = !@regexp_flag
              else
                new_line += ch
              end
            elsif ch =~ /\|/
              new_line += add_block_arg_id(ch) unless @comment_flag || @text_flag || @all_text_flag || @regexp_flag
            elsif ch =~ /(\^|\$){1}/
              new_line += add_keyword_id(ch) if @regexp_flag
            else
              new_line += ch
            end
          end
        end
      end
    end

    return new_line
  end

  def count_end_num(filename)
    file = File.open(filename) 
    file.readlines.each do |text|
      if text =~ /^\s*end\s*$/ 
      @end_count += 1 
    end
  end
  file.close
  return @end_count
end

def parse_code(filename)

  count_end_num(filename)

  file = File.open(filename) 

  file.readlines.each do |text|
    @new_code += parse_line(text)
  end

  file.close
  puts @new_code
  return @new_code
end
end
