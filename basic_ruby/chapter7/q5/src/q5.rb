class Q5
    def make_gs_gen(arg1, arg2)
        count = 1
        value = 0
        f = Proc.new {
            if count == 1
                count += 1
                value = arg1
            else
                count += 1
                value *= arg2
            end
        }
        f
    end
end
