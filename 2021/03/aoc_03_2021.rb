#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2021/day/3

# --- Day 3: Binary Diagnostic ---
# The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

# The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions of the submarine. The first parameter to check is the power consumption.

# You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

# Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:

# 00100
# 11110
# 10110
# 10111
# 10101
# 01111
# 00111
# 11100
# 10000
# 11001
# 00010
# 01010
# Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.

# The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

# The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

# So, the gamma rate is the binary number 10110, or 22 in decimal.

# The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.

# Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)


# PART 2

# Next, you should verify the life support rating, which can be
# determined by multiplying the oxygen generator rating by the CO2
# scrubber rating.

# Both the oxygen generator rating and the CO2 scrubber rating are
# values that can be found in your diagnostic report - finding them is
# the tricky part. Both values are located using a similar process
# that involves filtering out values until only one remains. Before
# searching for either rating value, start with the full list of
# binary numbers from your diagnostic report and consider just the
# first bit of those numbers. Then:

# Keep only numbers selected by the bit criteria for the type of
# rating value for which you are searching. Discard numbers which do
# not match the bit criteria.  If you only have one number left, stop;
# this is the rating value for which you are searching.  Otherwise,
# repeat the process, considering the next bit to the right.  The bit
# criteria depends on which type of rating value you want to find:

# To find oxygen generator rating, determine the most common value (0
# or 1) in the current bit position, and keep only numbers with that
# bit in that position. If 0 and 1 are equally common, keep values
# with a 1 in the position being considered.  To find CO2 scrubber
# rating, determine the least common value (0 or 1) in the current bit
# position, and keep only numbers with that bit in that position. If 0
# and 1 are equally common, keep values with a 0 in the position being
# considered.  For example, to determine the oxygen generator rating
# value using the same example diagnostic report from above:

# Start with all 12 numbers and consider only the first bit of each
# number. There are more 1 bits (7) than 0 bits (5), so keep only the
# 7 numbers with a 1 in the first position: 11110, 10110, 10111,
# 10101, 11100, 10000, and 11001.  Then, consider the second bit of
# the 7 remaining numbers: there are more 0 bits (4) than 1 bits (3),
# so keep only the 4 numbers with a 0 in the second position: 10110,
# 10111, 10101, and 10000.  In the third position, three of the four
# numbers have a 1, so keep those three: 10110, 10111, and 10101.  In
# the fourth position, two of the three numbers have a 1, so keep
# those two: 10110 and 10111.  In the fifth position, there are an
# equal number of 0 bits and 1 bits (one each). So, to find the oxygen
# generator rating, keep the number with a 1 in that position: 10111.
# As there is only one number left, stop; the oxygen generator rating
# is 10111, or 23 in decimal.  Then, to determine the CO2 scrubber
# rating value from the same example above:

# Start again with all 12 numbers and consider only the first bit of
# each number. There are fewer 0 bits (5) than 1 bits (7), so keep
# only the 5 numbers with a 0 in the first position: 00100, 01111,
# 00111, 00010, and 01010.  Then, consider the second bit of the 5
# remaining numbers: there are fewer 1 bits (2) than 0 bits (3), so
# keep only the 2 numbers with a 1 in the second position: 01111 and
# 01010.  In the third position, there are an equal number of 0 bits
# and 1 bits (one each). So, to find the CO2 scrubber rating, keep the
# number with a 0 in that position: 01010.  As there is only one
# number left, stop; the CO2 scrubber rating is 01010, or 10 in
# decimal.  Finally, to find the life support rating, multiply the
# oxygen generator rating (23) by the CO2 scrubber rating (10) to get
# 230.

# Use the binary numbers in your diagnostic report to calculate the
# oxygen generator rating and CO2 scrubber rating, then multiply them
# together. What is the life support rating of the submarine? (Be sure
# to represent your answer in decimal, not binary.)


def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = 0
  data = []
  input_data.each_line do |line|
    #data << Integer(line.chomp)
    data << line.chomp
  end
  puts "input_data lines = #{data.length}  num_bits = #{data[0].length}"
  data
end

def write_output(file_name, output)
  #File.write(file_name, output.join("\n"), mode: 'w')
end

def flip_all_bits(x, num_bits)
  # this is the binary with all number 1's on
  mask = ("1"*num_bits).to_i(2)
  puts "mask=#{mask} #{mask.to_s(2)}"
  # xor your number
  x ^ mask
end


def calc_power(lines, output)
  #num_bits = lines[0].to_s(2).length
  num_bits = lines[0].length
  #num_bits = Integer(lines[0]).bit_length
  bit_freq = Hash.new
  bit_freq = {
    '0' => [],
    '1' => []
  }
  (0..num_bits-1).each do |b|
    bit_freq['0'][b] = 0
    bit_freq['1'][b] = 0
  end
  pp bit_freq

  lines.each do |line|
    #puts line
    #num = Integer(line)
    num = line.to_i(2)
    (0..num_bits-1).each do |b|
      mask = 0b1<<b
      if num & mask == 0
        bit_freq['0'][b] += 1
      else
        bit_freq['1'][b] += 1
      end
      #puts "b=#{b} 0=#{num & mask == 0} num=#{("%04b" % num)} mask=#{mask.to_s(2)}"
    end
    #pp bit_freq
  end
  pp bit_freq

  gamma_rate_str = ""
  (0..num_bits-1).each do |b|
    if bit_freq['0'][b] > bit_freq['1'][b]
      gbit = "0"
    elsif bit_freq['1'][b] > bit_freq['0'][b]
      gbit = "1"
    else
      puts "gamma bit #{b} are equal"
      raise
    end
    gamma_rate_str += gbit
  end
  # puts "gamma_rate_str=#{gamma_rate_str}"
  gamma_rate_str.reverse!
  gamma_rate = gamma_rate_str.to_i(2)
  puts "gamma_rate_str=#{gamma_rate_str}  #{gamma_rate}"
  epsilon_rate = flip_all_bits(gamma_rate, num_bits)
  puts "epsilon_rate_str=#{("%05b" % epsilon_rate)}  #{epsilon_rate}"
  power = epsilon_rate * gamma_rate
  puts "power=#{power}"
end

def calc_most(lines, num_bits)
  (0..num_bits-1).each do |b|
    mask = 0b1<<b
    zeros = []
    ones = []
    lines.each do |line|
      num = line.reverse.to_i(2)
      if num & mask == 0
        zeros << line
      else
        ones << line
      end
      # puts "#{line} b=#{b} 0=#{num & mask == 0} num=#{("%04b" % num)} mask=#{mask.to_s(2)}"
    end
    if zeros.length > ones.length
      lines = zeros
    elsif zeros.length < ones.length
      lines = ones
    else
      lines = ones
    end
    # puts "zeros=#{zeros.length}  ones=#{ones.length} lines=#{lines.length}"
    # pp lines
    if lines.length == 1
      puts "lines=#{lines} done searching most. #{b+1} bits checked"
      break
    end
  end
  lines[0]
end

def calc_least(lines, num_bits)
  (0..num_bits-1).each do |b|
    mask = 0b1<<b
    zeros = []
    ones = []
    lines.each do |line|
      num = line.reverse.to_i(2)
      if num & mask == 0
        zeros << line
      else
        ones << line
      end
      #puts "#{line} b=#{b} 0=#{num & mask == 0} num=#{("%04b" % num)} mask=#{mask.to_s(2)}"
    end
    if zeros.length < ones.length
      lines = zeros
    elsif zeros.length > ones.length
      lines = ones
    else
      lines = zeros
    end
    # puts "zeros=#{zeros.length}  ones=#{ones.length} lines=#{lines.length}"
    # pp lines
    if lines.length == 1
      puts "lines=#{lines} done searching least. #{b+1} bits checked"
      break
    end
  end
  lines[0]
end


def calc_life_support(lines, output)
  num_bits = lines[0].length

  o2_rating_str = calc_most(lines, num_bits)
  o2_rating = o2_rating_str.to_i(2)
  puts "o2_rating_str=#{o2_rating_str}  #{o2_rating}"

  co2_rating_str = calc_least(lines, num_bits)
  co2_rating = co2_rating_str.to_i(2)
  puts "co2_rating_str=#{co2_rating_str}  #{co2_rating}"
  
  puts "life support rating #{co2_rating * o2_rating}"
end

def part1(data, output_file)
  output = []
  calc_power(data, output)
end

def part2(data, output_file)
  output = []
  calc_life_support(data, output)
  write_output(output_file, output)

end

puts ""
puts "part 1 sample"
sample_data = read_input('aoc_03_2021_input_sample.txt')
part1(sample_data, 'aoc_03_2021_output_part1_sample.txt')

puts ""
puts "part 1"
data = read_input('aoc_03_2021_input_part1.txt')
part1(data, 'aoc_03_2021_output_part1.txt')

puts ""
puts "part 2 sample"
part2(sample_data, 'aoc_03_2021_output_part2_sample.txt')

puts ""
puts "part 2"
part2(data, 'aoc_03_2021_output_part2.txt')
