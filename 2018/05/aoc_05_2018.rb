#!/usr/bin/env ruby
require 'pry'

# You've managed to sneak in to the prototype suit manufacturing lab. The Elves are making decent progress, but are still struggling with the suit's size reduction capabilities.

# While the very latest in 1518 alchemical technology might have solved their problem eventually, you can do better. You scan the chemical composition of the suit's material and discover that it is formed by extremely long polymers (one of which is available as your puzzle input).

# The polymer is formed by smaller units which, when triggered, react with each other such that two adjacent units of the same type and opposite polarity are destroyed. Units' types are represented by letters; units' polarity is represented by capitalization. For instance, r and R are units with the same type but opposite polarity, whereas r and s are entirely different types and do not react.

# For example:

# In aA, a and A react, leaving nothing behind.
# In abBA, bB destroys itself, leaving aA. As above, this then destroys itself, leaving nothing.
# In abAB, no two adjacent units are of the same type, and so nothing happens.
# In aabAAB, even though aa and AA are of the same type, their polarities match, and so nothing happens.
# Now, consider a larger example, dabAcCaCBAcCcaDA:

# dabAcCaCBAcCcaDA  The first 'cC' is removed.
# dabAaCBAcCcaDA    This creates 'Aa', which is removed.
# dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
# dabCBAcaDA        No further actions can be taken.
# After all possible reactions, the resulting polymer contains 10 units.

# How many units remain after fully reacting the polymer you scanned?
# (Note: in this puzzle and others, the input is large; if you
# copy/paste your input, make sure you get the whole thing.)


def read_input(file_name)

  all_inputs = Array.new
  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    all_inputs << input
  end
  return all_inputs[0]
end

def build_regex(skip_letter)
  str = ''
  'a'.upto('z') do |l|
    next if l == skip_letter
    x = l + l.upcase()
    y = l.upcase() + l
    str = "#{str}|#{x}|#{y}"
  end
  return str[1..-1]
end

def remove_units(input)
  polymers = Hash.new
  'a'.upto('z') do |l|
    x = l + '|' + l.upcase()
    rem_polymer = input.gsub(/#{x}/, '')
    if rem_polymer.length == input.length
      puts "Input polymer doesn't contain #{x}"
      next
    else
      puts "Removed #{x}, reacting"
    end
    polymers[l] = reactions(rem_polymer, l)
  end
  sorted_polymers = polymers.sort_by {|_key, value| value}

  puts "Shortest polymer with unit removed: #{sorted_polymers.first}"
end

def reactions(input, skip_letter)
  regex_str = build_regex(skip_letter)
  regex = Regexp.new(regex_str)
  result = input
  puts "Starting reactions: #{result.length}"
  while true
    start_len = result.length
    #result = result.gsub(/aA|Aa|cC|Cc/, '')
    #result = result.gsub('aA|Aa|cC|Cc', '')
    result = result.gsub(regex, '')
    if result.length == start_len
      #puts "No more reactions: #{result.length} #{result}"
      puts "No more reactions: #{result.length}"
      break
    else
      #puts "More reactions:    #{result.length} #{result}"
      #puts "More reactions:    #{result.length}"
    end
  end
  return result.length
end

all_inputs = read_input('sample.txt')
#puts "len=#{all_inputs.length} #{all_inputs}"
puts "Start sample"
reactions(all_inputs, nil)
remove_units(all_inputs)

puts "Start real input"
all_inputs = read_input('aoc_05_2018_input.txt')
reactions(all_inputs, nil)
remove_units(all_inputs)
