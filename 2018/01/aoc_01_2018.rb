#!/usr/bin/env ruby

# https://adventofcode.com/2018/day/1

# After feeling like you've been falling for a few minutes, you look
# at the device's tiny screen. "Error: Device must be calibrated
# before first use. Frequency drift detected. Cannot maintain
# destination lock." Below the message, the device shows a sequence of
# changes in frequency (your puzzle input). A value like +6 means the
# current frequency increases by 6; a value like -3 means the current
# frequency decreases by 3.

# For example, if the device displays frequency changes of +1, -2, +3, +1, then starting from a frequency of zero, the following changes would occur:

# Current frequency  0, change of +1; resulting frequency  1.
# Current frequency  1, change of -2; resulting frequency -1.
# Current frequency -1, change of +3; resulting frequency  2.
# Current frequency  2, change of +1; resulting frequency  3.
# In this example, the resulting frequency is 3.

# Here are other example situations:

# +1, +1, +1 results in  3
# +1, +1, -2 results in  0
# -1, -2, -3 results in -6

# Starting with a frequency of zero, what is the resulting frequency after all of the changes in frequency have been applied?


def read_input(file_name, total, freqs)
  twice = nil
  
  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp
    #raise if input.nil?
    #num = input.strip!.to_i
    num = Integer(input)
    puts "#{input} #{num} #{total}"
    total += num
    if freqs.has_key?(total.to_s)
      puts "freq exists #{total.to_s}"
      if twice.nil?
        twice = total
        #puts "**************"
        # once we find a freq occurs twice stop looking
        break
      end
    else
      freqs[total.to_s] = true
    end
  end
  return total, twice
end

freqs = Hash.new
total = Integer(0)

(total, twice) = read_input('aoc_01_2018_input.rb', total, freqs)
puts "total #{total}"

0.upto(1000) do |i|
  total, twice = read_input('aoc_01_2018_input.rb', total, freqs)
  unless twice.nil?
    puts "found twice #{twice} i=#{i}"
    break
  end
end

