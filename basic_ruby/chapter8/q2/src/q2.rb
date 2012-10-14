# encoding: utf-8

class Person
    def age
        @age
    end

    def age=(age)
        raise "整数でない値が入力されました" if age.class != Fixnum
        raise "負の値が入力されました" if age < 0
    end
end
