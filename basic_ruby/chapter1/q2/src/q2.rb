class Q2 
    def for_hundred_print()
        for i in 1..100
            print "#{i}: Hello Ruby!\n"
        end
    end

    def each_hundred_print()
        (1..100).each do |i|
            print "#{i}: Hello Ruby!\n"
        end
    end

    def times_hundred_print()
        100.times do |i|
            print "#{i+1}: Hello Ruby!\n"
        end
    end
end

q = Q2.new
q.times_hundred_print
