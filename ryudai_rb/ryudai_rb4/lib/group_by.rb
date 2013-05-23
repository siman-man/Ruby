require 'ostruct'

students = []
students << OpenStruct.new({name: "siman", eng: 90, math: 90, science: 90, ave: 90})
students << OpenStruct.new({name: "hoge", eng: 80, math: 70, science: 30, ave: 60})
students << OpenStruct.new({name: "piyo", eng: 0, math: 100, science: 20, ave: 40})

group = students.group_by do |student|
  case student.ave
  when 0...20
    "E"
  when 20...40
    "D"
  when 40...60
    "C"
  when 60...80
    "B"
  when 80..100
    "A"
  end
end

group.each do |rank, students|
  students.each do |student|
    puts "#{student.name}さんのランクは#{rank}です。"
    puts "英語の得点 : %3d点" % [student.eng]
    puts "数学の得点 : %3d点" % [student.math]
    puts "科学の得点 : %3d点" % [student.science]
    puts "    平均点 : %3d点" % [student.ave]
    puts "------------------------------------------"
  end
end
