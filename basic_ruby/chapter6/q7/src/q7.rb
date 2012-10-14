class Person
    attr_accessor :strength, :cleverness

    def initialize
        @strength = 10
        @cleverness = 20
    end

    def base_strength
        @strength.to_f
    end

    def base_cleverness
        @cleverness.to_f
    end

end

class Fighter < Person
    attr_accessor :strength, :cleverness

    def initialize
        @strength = base_strength * 1.5
        @cleverness = base_cleverness
    end
end

class Wizard < Person
    attr_accessor :strength, :cleverness

    def initialize
        @strength = base_strength * 0.5
        @cleverness = base_cleverness * 3.0
    end
end
