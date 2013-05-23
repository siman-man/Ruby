#!/usr/bin/env ruby
ARGV.instance_eval do
  exit if empty?

  width = size >= 2 ? map(&:size).max : 1
  border = "+#{'-' * width}+"

  puts border
  each {|line|
    puts format("|%-*s|", width, line[0...width])
    puts border
  }
end
