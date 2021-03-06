# encoding: utf-8

class Q4
    def msg_calc(msg)
        value = 0
        /[あ-を]+/ =~ msg
        operator = $&
        case operator
        when 'たす'
            value = $`.to_f + $'.to_f
        when 'ひく'
            value = $`.to_f - $'.to_f
        when 'かける'
            value = $`.to_f * $'.to_f
        when 'わる'
            value = $`.to_f / $'.to_f
        end
        return value
    end
end
