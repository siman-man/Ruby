class Q2
    def one_dim2two_dim(one)
        b = Array.new(5) do
            [0, 0, 0]
        end
        one.each_with_index do |i, index|
            (0..2).each do |j|
                if(index < one.size - 2)
                    b[index][j] = one[index+j]
                end
            end
        end
        return b
    end
end
