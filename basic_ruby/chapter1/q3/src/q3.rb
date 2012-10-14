class Q3
    def hundred_print()
       (1..100).each do |i|
           print return_message(i)
       end 
    end

    def return_message(val)
        if((val%15) == 0)
            return "This argument is a multiple of 5\n"
        elsif((val%3) == 0) 
            return "Hello Ruby\n"
        end
    end
end

