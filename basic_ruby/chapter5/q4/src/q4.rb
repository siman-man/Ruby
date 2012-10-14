# encoding: utf-8
class Q4 
    def initialize
        @jp_name = { "1" => "睦月", "2" => "如月", "3" => "弥生", "4" => "卯月",
                    "5" => "皐月", "6" => "水無月", "7" => "文月", "8" => "葉月",
                    "9" => "長月", "10" => "神無月", "11" => "霜月", "12" => "師走"}
    end

    def month_conv_jp(value)
        @jp_name[value]
    end
end
