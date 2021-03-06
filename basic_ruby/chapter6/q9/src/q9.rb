class Money 
    attr_reader :currency

    def initialize(c)
        @currency = c
    end

    def eql?(other)
        other.class == self.class && other.currency == currency && other.value == self.value
    end

    def eql_currency?(other)
        other.class == self.class && other.currency == currency
    end
end

class Yen < Money
    attr_reader :value

    def initialize(v)
        super("YEN")
        @value = v
    end
end
