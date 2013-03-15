# encoding: utf-8

class Integer
  def to_yen
    self.to_j + "円"
  end

  def to_j
    cardinal = %w(零 一 二 三 四 五 六 七 八 九)
    base_unit = %w(十 百 千)
    unit = %w(万 億 兆 京 垓 予 穣 溝 澗 正 裁 極 恒河沙 阿僧祇 那由多 不可思議 無量大数
              洛叉 倶胝)

    return "零" if self == 0

    numbers = []

    self.to_s.each_char{ |num| numbers << num.to_i }

    number_blocks = numbers.reverse.each_slice(4).to_a

    japanese = ""
    block_size = number_blocks.size

    number_blocks.reverse.each_with_index do |block, index|
      str = ""
      block.each_with_index do |num, unit|
        if num != 0
          str += base_unit[unit-1] if unit.nonzero?

          if num == 1
            if unit == 0 || unit == 3
              if index != block_size-1
                str += cardinal[num] 
              else
                str += cardinal[num] if str.size == 0
              end
            end
          else
            str += cardinal[num]
          end
        end
      end
      japanese += str.reverse
      japanese += unit[number_blocks.size-(index+2)] if str.size.nonzero? && block_size != index+1
    end

    japanese
  end
end
