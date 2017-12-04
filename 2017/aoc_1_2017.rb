#!/usr/bin/env ruby

# http://adventofcode.com/2017/day/1
#
# The captcha requires you to review a sequence of digits (your puzzle
# input) and find the sum of all digits that match the next digit in
# the list. The list is circular, so the digit after the last digit is
# the first digit in the list.
#
# For example:
#
# 1122 produces a sum of 3 (1 + 2) because the first digit (1) matches
# the second digit and the third digit (2) matches the fourth digit.
#
# 1111 produces 4 because each digit (all 1) matches the next.
#
# 1234 produces 0 because no digit matches the next.
#
# 91212129 produces 9 because the only digit that matches the next one
# is the last digit, 9.


require 'pry'


def sum_seq(input_str, answer)
  data = input_str.split('')
  total = 0
  i = 0
  data.each do |cur_ch|
    if cur_ch == data[i+1]
      #puts "Cur #{cur_ch} idx #{i}"
      total += cur_ch.to_i
    end
    i += 1
  end
  if data[0] == data[-1]
    total += data[0].to_i
  end
  puts "Total #{total} Answer #{answer} input #{input_str[0..40]}"
end

def sum_seq2(input_str, answer)
  look_ahead = input_str.length/2
  data = input_str.split('')
  total = 0
  i = 0
  data.each do |cur_ch|
    if cur_ch == data[i+look_ahead]
      #puts "Cur #{cur_ch} idx #{i}"
      total += cur_ch.to_i*2
    end
    i += 1
#    binding.pry
    break if i > input_str.length/2

  end
  # if data[0] == data[-1]
  #   total += data[0].to_i
  # end
  puts "Total #{total} Answer #{answer} input #{input_str[0..40]}"
end

def read_input(file_name, method)
  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    next if line.start_with?('#')
    next if line.chomp.empty?
    (input, answer) = line.chomp.split('=')
    raise if input.nil?
    input.strip!
    if answer.nil?
      answer = '?'
    else
      answer.strip!
    end
    if method.nil?
      puts "No method. Answer #{answer} input #{input[0..40]}"
    else
      send(method, input, answer)
    end
  end
end



file_name = 'aoc_1_2017_data1.txt'
read_input(file_name, :sum_seq)

file_name = 'aoc_1_2017_data2.txt'
read_input(file_name, :sum_seq2)
