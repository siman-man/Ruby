class Q3
    def method2(n)
        if block_given?
            yield(n)
        else
            n
        end
    end
end
