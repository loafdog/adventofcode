#!/usr/bin/env ruby

# https://adventofcode.com/2018/day/2

# To make sure you didn't miss any, you scan the likely candidate
# boxes again, counting the number that have an ID containing exactly
# two of any letter and then separately counting those with exactly
# three of any letter. You can multiply those two counts together to
# get a rudimentary checksum and compare it to what your device
# predicts.

# For example, if you see the following box IDs:

# abcdef contains no letters that appear exactly two or three times.
# bababc contains two a and three b, so it counts for both.
# abbcde contains two b, but no letter appears exactly three times.
# abcccd contains three c, but no letter appears exactly two times.
# aabcdd contains two a and two d, but it only counts once.
# abcdee contains two e.
# ababab contains three a and three b, but it only counts once.

# Of these box IDs, four of them contain a letter which appears
# exactly twice, and three of them contain a letter which appears
# exactly three times. Multiplying these together produces a checksum
# of 4 * 3 = 12.

# What is the checksum for your list of box IDs?

def count_letters(line, all_inputs)
  freq = Hash.new
  line.chars do |c|
    if freq.has_key?(c)
      freq[c] += 1
    else
      freq[c] = 1
    end
  end
  if freq.value?(2)
    two_letters = 1
  else
    two_letters = 0
  end
  if freq.value?(3)
    three_letters = 1
  else
    three_letters = 0
  end
  if freq.value?(4)
    puts "4 letters!"
  end
  #puts "#{line.chars.sort} two_l=#{two_letters} three_l=#{three_letters}"
  puts "#{line} two_l=#{two_letters} three_l=#{three_letters}"
  all_inputs[line] = {
    '2' => two_letters,
    '3' => three_letters
  }
  return two_letters, three_letters
end


def compare_chars(boxA, boxB, comps, msg)
  diff = 0
  str = ''
  boxA.each_index do |i|
    if boxA[i] != boxB[i]
      diff += 1
      str << '_'
    else
      str << boxA[i]
    end
    if diff > 1
      puts str
      return false
    end
  end
  puts "FOUND IT: #{msg} comps=#{comps}  #{str}"
  return true
end

# Ruby array subtract removes chars that exit regardless of position.
# If RHS contains all the chars in LHS then diff will be empty array.
# That means that the arrays could contain same chars exactly, or some
# chars are repeated. Regardless this gives a good hint to compare
# positions since arrays could contain same chars at each position.
def subtract(boxes, all_inputs)
  puts "Searching using subtract"
  comps = 0
  inner=0
  0.upto(boxes.length-1) do |i|
    inner += 1
    inner.upto(boxes.length-1) do |j|
      diff = boxes[i].chars - boxes[j].chars
      # puts "#{boxes[i]}  #{boxes[j]}  #{diff}"
      if diff.length == 0
        puts "#{boxes[i]}  #{boxes[j]}  #{diff}"
        if compare_chars(boxes[i].chars, boxes[j].chars, comps, 'subtract')
          puts "#{boxes[i]} #{all_inputs[boxes[i]]}"
          puts "#{boxes[j]} #{all_inputs[boxes[j]]}"
        end
        comps += 1
      end
    end
  end
end

def brute_force(boxes)
  puts "Searching using brute force"
  comps = 0
  inner=0
  0.upto(boxes.length-1) do |i|
    inner += 1
    inner.upto(boxes.length-1) do |j|
      puts "#{boxes[i]}  #{boxes[j]}"
      return if compare_chars(boxes[i].chars, boxes[j].chars, comps, 'brute force')
      comps += 1
    end
  end
end

def read_input(file_name)
  all_inputs = Hash.new
  
  single_boxes = []
  double_or_single_boxes = []
  triple_boxes = []
  boxes = []
  two_letters = 0
  three_letters = 0

  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    boxes << input
    #raise if input.nil?
    #num = input.strip!.to_i
    two_l, three_l = count_letters(input, all_inputs)
    two_letters += two_l
    three_letters += three_l
    if two_l == 0 && three_l == 0
      single_boxes << input
    end
    if three_l == 0
      double_or_single_boxes << input
    end
    if three_l == 1
      triple_boxes << input
    end

  end
  checksum = two_letters * three_letters
  puts "cksum=#{checksum}  two_l=#{two_letters} three_l=#{three_letters}"

  #puts boxes
  # puts single_boxes
  # puts "num single letter boxes #{single_boxes.length}"
  # puts double_or_single_boxes
  # puts "num double or single letter boxes #{double_or_single_boxes.length}"

  puts triple_boxes
  puts "num triple letter boxes #{triple_boxes.length}"
  
  puts "num all boxes #{boxes.length}"

  #subtract(triple_boxes)

  subtract(boxes, all_inputs)
  
  brute_force(boxes)
  
end


read_input('aoc_02_2018_input.txt')
