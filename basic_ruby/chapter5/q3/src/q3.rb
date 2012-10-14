class Q3
    def asc_order(array)
        array.sort
    end

    def des_order(array)
        array.sort.reverse
    end

    def sum(array)
        array.inject(0){|count, i| count += i}
    end

    def average(array)
        sum = sum(array)
        sum / array.size
    end
end
