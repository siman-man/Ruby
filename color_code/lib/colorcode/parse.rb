require 'strscan'

class Parse
  attr_reader :def_name_flag, :class_name_flag
  attr_accessor :end_count

  def initialize
    @end_count = 0
    @def_name_flag = false
    @class_name_flag = false
    @module_name_flag = false
    @text_flag = false
    @all_text_flag = false
    @formula_flag = false
    @formula_text = ''
    @comment_flag = false
    @regexp_flag = false
    @block_arg_flag = false
    @not_add_end = false
    @end_list = []
    @accessor_list = ['attr_reader', 'attr_writer', 'attr_accessor']

    @tag_id_list = ['else', 'when', 'case', 'number', 
      'for', 'loop', 'break', 'in', 'accessor', 
      'then', 'elsif', 'return', 'true', 'false',
      'instance', 'block_arg', 'constant', 'symbol']
    @tag_id_list.each do |word|
      Parse.define_id_tag(word) 
    end

    @end_tag_list = ['def', 'class', 'module', 'while', 'until', 'case', 'loop',
    'until']
    @end_tag_list.each do |word|
      Parse.define_end_tag(word) 
    end
  end

  def tag_judge
    @text_flag || @all_text_flag || @regexp_flag || @comment_flag || @block_arg_flag
  end

  def add_include_id(word)
    if @formula_flag
      '<span id="include">' + word + '</span>'
    elsif tag_judge 
      word
    else
      '<span id="include">' + word + '</span>'
    end
  end

  def add_if_id(word, index)
    if tag_judge 
      word
    elsif index <= 1
      @end_list.push('if')
      '<span id="if">' + word + '</span>'
    else
      '<span id="if">' + word + '</span>'
    end
  end

  def add_unless_id(word, index)
    if tag_judge 
      word
    elsif index <= 1
      @end_list.push('unless')
      '<span id="unless">' + word + '</span>'
    else
      '<span id="unless">' + word + '</span>'
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

  def add_escape_id(word)
    '<span id="escape">' + word + '</span>'
  end

  def add_keyword_id(ch)
    '<span id="keyword">' + ch + '</span>'
  end

  def add_def_name_id(word)
    @def_name_flag = false
    '<span id="def_name">' + word + '</span>'
  end

  def add_class_name_id(word)
    @class_name_flag = false
    '<span id="class_name">' + word + '</span>'
  end

  def add_module_name_id(word)
    @module_name_flag = false
    '<span id="module_name">' + word + '</span>'
  end

  def add_end_id(word)

    case @end_list.pop
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

  def upper?(str)
    /[A-Z]/ =~ str
  end

  def sentence2words(text)
    scanner = StringScanner.new(text)
    words = []
    until scanner.eos?
      words.push scanner.scan(/(@|\w|\d|_|=|:)+|\s+|\#{|(\+|\-|\*|\/|=)+|\\([a-z]|[A-Z]|("|')|\/){1}|\W|\S+/)
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

  def self.define_end_tag(name)
    define_method :"add_#{name}_id" do |word|
      if tag_judge
        word
      else
        @not_add_end = true
        eval("@#{name}_name_flag = true") if word != 'do'
        eval("@end_list.push('#{name}')")
        "<span id=\"#{name}\">" + word + '</span>'
      end
    end
  end

  def add_do_id(word)
    if tag_judge
      word
    else
      @end_list.push('do') unless @not_add_end
      '<span id="do">' + word + '</span>'
    end
  end


  def parse_line(text)
    new_line = ''
    result = sentence2words(text)

    result.each_with_index do |word, index|
      if @tag_id_list.include?(word) && !tag_judge
        eval("new_line += add_#{word}_id(word)")
        next
      end
      
      if @accessor_list.include?(word) && !tag_judge
        new_line += add_accessor_id(word)
        next
      end

      case word
      when 'def'
        new_line += add_def_id(word) 
      when 'class'
        new_line += add_class_id(word) 
      when 'module'
        new_line += add_module_id(word) 
      when 'while'
        new_line += add_while_id(word) 
      when 'end'
        unless tag_judge 
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
      when 'include'
        new_line += add_include_id(word)
      else
        if word =~ /^@(\d|\w|_)+/
          new_line += add_instance_id(word) unless tag_judge
        elsif word =~ /^:(\d|\w|_)+/
          new_line += add_symbol_id(word) unless tag_judge
        elsif @def_name_flag && /\w+/ =~ word
          new_line += add_def_name_id(word) 
        elsif @block_arg_flag && /(\w|\d|[0-9]|\_)+/ =~ word
          new_line += add_block_arg_id(word) 
        elsif upper?(word[0])
          if !@text_flag && !@regexp_flag && !@all_text_flag
            new_line += add_constant_id(word)
          elsif @regexp_flag
            new_line += word
          else
            new_line += word
          end
        elsif word =~ /^[0-9]+/
          new_line += add_number_id(word) unless tag_judge 
          new_line += word if tag_judge 
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
              new_line += add_comment_id(ch) unless tag_judge
            elsif ch =~ /\n/
              if @comment_flag
                new_line += add_comment_id(ch)
                @comment_flag = false
              else
                new_line += ch 
              end
            @not_add_end = false
            elsif ch =~ /\//
              unless @comment_flag || @text_flag || @all_text_flag
                new_line += add_regexp_id(ch)
                @regexp_flag = !@regexp_flag
              else
                new_line += ch
              end
            elsif ch =~ /\|/
              @block_arg_flag = !@block_arg_flag unless @all_text_flag || @regexp_flag || @text_flag || @regexp_flag
              new_line += ch
            elsif ch =~ /(\^|\$){1}/
              new_line += add_keyword_id(ch) if @regexp_flag
            else
              new_line += ch
            end
          end
        end
      end
    end

    new_line
  end

  def parse_code(filename)
    new_code = ''

    File.open(filename) do |file|
      file.readlines.each do |line|
        new_code += parse_line(line)
      end
    end

    new_code
  end
end
