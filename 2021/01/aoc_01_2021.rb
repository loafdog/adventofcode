#!/usr/bin/env ruby

# https://adventofcode.com/2021/day/1

# --- Day 1: Sonar Sweep ---
# You're minding your own business on a ship at sea when the overboard alarm goes off! You rush to see if you can help. Apparently, one of the Elves tripped and accidentally sent the sleigh keys flying into the ocean!

# Before you know it, you're inside a submarine the Elves keep ready for situations like this. It's covered in Christmas lights (because of course it is), and it even has an experimental antenna that should be able to track the keys if you can boost its signal strength high enough; there's a little meter that indicates the antenna's signal strength by displaying 0-50 stars.

# Your instincts tell you that in order to save Christmas, you'll need to get all fifty stars by December 25th.

# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

# As the submarine drops below the surface of the ocean, it automatically performs a sonar sweep of the nearby sea floor. On a small screen, the sonar sweep report (your puzzle input) appears: each line is a measurement of the sea floor depth as the sweep looks further and further away from the submarine.

# For example, suppose you had the following report:

# 199
# 200
# 208
# 210
# 200
# 207
# 240
# 269
# 260
# 263
# This report indicates that, scanning outward from the submarine, the sonar sweep found depths of 199, 200, 208, 210, and so on.

# The first order of business is to figure out how quickly the depth increases, just so you know what you're dealing with - you never know if the keys will get carried into deeper water by an ocean current or a fish or something.

# To do this, count the number of times a depth measurement increases from the previous measurement. (There is no measurement before the first measurement.) In the example above, the changes are as follows:

# 199 (N/A - no previous measurement)
# 200 (increased)
# 208 (increased)
# 210 (increased)
# 200 (decreased)
# 207 (increased)
# 240 (increased)
# 269 (increased)
# 260 (decreased)
# 263 (increased)
# In this example, there are 7 measurements that are larger than the previous measurement.

# How many measurements are larger than the previous measurement?

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = 0
  data = []
  input_data.each_line do |line|
    i = Integer(line.chomp!)
    data << i
  end
  puts "input_data length = #{input_data.length} lines = #{data.length}"
  data
end

def write_output(file_name, output)
  File.write(file_name, output.join("\n"), mode: 'w')
end

def count_increases(lines, output)
  prev = nil
  inc = 0
  dec = 0
  eq = 0
  lines.each do |line|
    if prev.nil?
      prev = line
      output << "#{line} n/a"
      next
    end
    if line > prev
      inc += 1
      output << "#{line} inc #{inc}"
    elsif line < prev
      output << "#{line} dec #{dec}"
      dec += 1
    else
      output << "#{line} eq #{eq}"
      eq += 1
    end
    prev = line
  end
  return inc, dec, eq
end

def count_increases_window(lines, window_size, output)

  inc = 0
  dec = 0
  eq = 0

  prev_window = nil
  lines.each_with_index do |line, index|
    break if index + window_size > lines.length
    next_window = 0
    #puts "index=[#{index}] line=[#{line}]"
    (index..index+window_size-1).each do |w|
      next_window += lines[w]
      #puts " next_window=#{next_window} w=#{w} #{lines[w]}"
    end

    if prev_window.nil?
      prev_window = next_window
      output << "#{line} n/a #{next_window}"
      next
    end
    if next_window > prev_window
      inc += 1
      output << "#{line} inc #{inc} #{next_window}"
    elsif next_window < prev_window
      output << "#{line} dec #{dec} #{next_window}"
      dec += 1
    else
      output << "#{line} eq #{eq} #{next_window}"
      eq += 1
    end
    prev_window = next_window
  end
  return inc, dec, eq
end

def part1(data, output_file)
  output = []
  inc,dec,eq = count_increases(data, output)
  write_output(output_file, output)
  puts "#{inc} increases #{dec} decreases eq=#{eq} total #{inc+dec+eq}"
end

def part2(data, output_file)
  output = []
  inc,dec,eq = count_increases_window(data, 3, output)
  write_output(output_file, output)
  puts "#{inc} increases #{dec} decreases eq=#{eq} total #{inc+dec+eq}"
end

sample_data = read_input('aoc_01_2021_sample_input.txt')
data = read_input('aoc_01_2021_input.txt')
puts ""
puts "part 1"
part1(sample_data, 'aoc_01_2021_sample_output.txt')
part1(data, 'aoc_01_2021_output.txt')
puts ""
puts "part 2"
part2(sample_data, 'aoc_01_2021_sample_output_part2.txt')
part2(data, 'aoc_01_2021_output_part2.txt')


