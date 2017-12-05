#!/usr/bin/env ruby

# http://adventofcode.com/2017/day/2
#
# The spreadsheet consists of rows of apparently-random numbers. To
# make sure the recovery process is on the right track, they need you
# to calculate the spreadsheet's checksum. For each row, determine the
# difference between the largest value and the smallest value; the
# checksum is the sum of all of these differences.
#
# For example, given the following spreadsheet:
#
# 5 1 9 5
# 7 5 3
# 2 4 6 8
#
# The first row's largest and smallest values are 9 and 1, and their difference is 8.
#
# The second row's largest and smallest values are 7 and 3, and their difference is 4.
#
# The third row's difference is 6.
#
# In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18

require 'pry'


def row_max_min(row)
  min = max = row[0].to_i

  row.each do |val|
    cell = val.to_i
    if cell < min
      min = cell
    end
    if cell > max
      max = cell
    end
  end
  [max, min]
end

def row_div(row)
  i = 0
  while i < row.length

    j = i + 1
    while j < row.length
      if row[i] % row[j] == 0
        return [row[i], row[j]]
      elsif row[j] % row[i] == 0
        return [row[j], row[i]]
      end
      j += 1
    end
    i += 1
  end
end

def max_min_diff(row)
  (max, min) = row_max_min(row)
  diff = max - min
  puts "#{max} - #{min} diff=#{diff}"
  diff
end

def div_quotient(row)
  (dividend, divisor) = row_div(row)
  quo = dividend / divisor
  puts "#{dividend} / #{divisor} quotient=#{quo}"
  quo
end

def read_input(file_name, method)
  file = File.open(file_name)
  input_data = file.read

  checksum = 0
  input_data.each_line do |line|
    next if line.start_with?('#')
    next if line.chomp.empty?
    if line.include?('checksum')
      parts = line.chomp.split('=')
      puts "Answer=#{parts[1]} checksum=#{checksum}"
      checksum = 0
      puts ""
    else
      row = line.chomp.split(' ').map(&:to_i)
      checksum += send(method, row)
    end
  end
end


file_name = 'aoc_2_2017_data1.txt'
read_input(file_name, :max_min_diff)

file_name = 'aoc_2_2017_data2.txt'
read_input(file_name, :div_quotient)

