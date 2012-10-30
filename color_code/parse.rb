require 'strscan'

class Parse
    def initialize
        @new_code = ''
    end

    def add_def_id(word)
        "<span id='def'>" + word + "</span>"
    end

    def add_class_id(word)
        "<span id='class'>" + word + "</span>"
    end

    def add_end_id(word)
        "<span id='end'>" + word + "</span>"
    end

    def parse_line(text)
        scanner = StringScanner.new(text)
        new_line = ''
        result = []
        until scanner.eos?
            result.push scanner.scan(/\w+|\W+/)
        end

        result.each do |word|
            case word
            when 'def'
                new_line += add_def_id(word)
            when 'class'
                new_line += add_class_id(word)
            when 'end'
                new_line += add_end_id(word)
            else
                new_line += word
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

