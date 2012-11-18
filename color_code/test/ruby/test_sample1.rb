module Test
  class Test
    def test
      while true > 4 
        puts "Hello World!" if false
      end

      [1, 2, 3].each_with_index do |number, index|
        puts number
      end
    end

    def test2
      while true do
        if true
          puts "Hello Ruby!"
        end
      end
    end
  end
end
