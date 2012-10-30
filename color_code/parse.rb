require 'strscan'

class Parse
    attr_reader :def_name_flag, :class_name_flag

    def initialize
        @new_code = ''
        @def_name_flag = false
        @class_name_flag = false
        @text_flag = false
    end

    def add_def_id(word)
        @def_name_flag = true
        "<span id='def'>" + word + "</span>"
    end

    def add_def_name_id(word)
        @def_name_flag = false
        "<span id='func_name'>" + word + "</span>"
    end

    def add_class_id(word)
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
        "<span id='end'>" + word + "</span>"
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
            words.push scanner.scan(/\w+|\W+/)
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
                else
                    word.each_char do |ch|
                        if(ch == '"')
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
        puts @new_code
        file.close
    end
end

