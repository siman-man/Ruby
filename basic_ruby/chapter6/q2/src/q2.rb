class Dog
    attr_reader :kind
    attr_accessor :bait

    def initialize(k="Mongrel")
        @kind = k
    end

    def meal(food)
       @bait = "OK" 
    end
    
    def feeling
        food = @bait
        @bait = "NO"
        food == "OK" ? "Good" : "Sad"
    end
end



