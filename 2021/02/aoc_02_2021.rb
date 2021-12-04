#!/usr/bin/env ruby

# https://adventofcode.com/2021/day/2

# --- Day 2: Dive! ---
# Now, you need to figure out how to pilot this thing.

# It seems like the submarine can take a series of commands like forward 1, down 2, or up 3:

# forward X increases the horizontal position by X units.
# down X increases the depth by X units.
# up X decreases the depth by X units.
# Note that since you're on a submarine, down and up affect your depth, and so they have the opposite result of what you might expect.

# The submarine seems to already have a planned course (your puzzle input). You should probably figure out where it's going. For example:

# forward 5
# down 5
# forward 8
# up 3
# down 8
# forward 2
# Your horizontal position and depth both start at 0. The steps above would then modify them as follows:

# forward 5 adds 5 to your horizontal position, a total of 5.
# down 5 adds 5 to your depth, resulting in a value of 5.
# forward 8 adds 8 to your horizontal position, a total of 13.
# up 3 decreases your depth by 3, resulting in a value of 2.
# down 8 adds 8 to your depth, resulting in a value of 10.
# forward 2 adds 2 to your horizontal position, a total of 15.
# After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)

# Calculate the horizontal position and depth you would have after following the planned course. What do you get if you multiply your final horizontal position by your final depth?

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = 0
  data = []
  input_data.each_line do |line|
    parts = line.chomp.split(' ')
    data << [parts[0], Integer(parts[1])]
  end
  puts "input_data lines = #{data.length}"
  data
end

def write_output(file_name, output)
  File.write(file_name, output.join("\n"), mode: 'w')
end

def calc(lines, output)
  depth = 0
  hor = 0
  lines.each do |line|
    case line[0]
    when 'forward'
      hor += line[1]
    when 'up'
      depth -= line[1]
    when 'down'
      depth += line[1]
    else
      puts "invalid action in line: [#{line}]"
    end
  end
  return depth, hor
end

def calc_aim(lines, output)
  depth = 0
  hor = 0
  aim = 0
  
  lines.each do |line|
    case line[0]
    when 'forward'
      hor += line[1]
      depth += line[1] * aim
    when 'up'
      aim -= line[1]
    when 'down'
      aim += line[1]
    else
      puts "invalid action in line: [#{line}]"
    end
    output << "#{line[0]} #{line[1]} aim=#{aim} d=#{depth} h=#{hor}"    
  end
  return depth, hor
end


def part1(data, output_file)
  output = []
  d,h = calc(data, output)
  puts "depth=#{d} h=#{h}  #{h*d}"
end

def part2(data, output_file)
  output = []
  d,h = calc_aim(data, output)
  write_output(output_file, output)
  puts "depth=#{d} h=#{h}  #{h*d}"
end



puts ""
puts "part 1 sample"
sample_data = read_input('aoc_02_2021_input_sample.txt')
part1(sample_data, 'aoc_02_2021_output_part1_sample.txt')

puts ""
puts "part 1"
data = read_input('aoc_02_2021_input_part1.txt')
part1(data, 'aoc_02_2021_output_part1.txt')

puts ""
puts "part 2 sample"
part2(sample_data, 'aoc_02_2021_output_part2_sample.txt')

puts ""
puts "part 2"
part2(data, 'aoc_02_2021_output_part2.txt')



