#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2021/day/7

# --- Day 7: The Treachery of Whales ---

# A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

# Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep for them otherwise) zooms in to rescue you! They seem to be preparing to blast a hole in the ocean floor; sensors indicate a massive underground cave system just beyond where they're aiming!

# The crab submarines all need to be aligned before they'll have enough power to blast a large enough hole for your submarine to get through. However, it doesn't look like they'll be aligned before the whale catches you! Maybe you can help?

# There's one major catch - crab submarines can only move horizontally.

# You quickly make a list of the horizontal position of each crab (your puzzle input). Crab submarines have limited fuel, so you need to find a way to make all of their horizontal positions match while requiring them to spend as little fuel as possible.

# For example, consider the following horizontal positions:

# 16,1,2,0,4,2,7,1,2,14

# This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

# Each change of 1 step in horizontal position of a single crab costs 1 fuel. You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2:

#     Move from 16 to 2: 14 fuel
#     Move from 1 to 2: 1 fuel
#     Move from 2 to 2: 0 fuel
#     Move from 0 to 2: 2 fuel
#     Move from 4 to 2: 2 fuel
#     Move from 2 to 2: 0 fuel
#     Move from 7 to 2: 5 fuel
#     Move from 1 to 2: 1 fuel
#     Move from 2 to 2: 0 fuel
#     Move from 14 to 2: 12 fuel

# This costs a total of 37 fuel. This is the cheapest possible outcome; more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

# Determine the horizontal position that the crabs can align to using the least fuel possible. How much fuel must they spend to align to that position?

# Your puzzle answer was 343468.
# --- Part Two ---

# The crabs don't seem interested in your proposed solution. Perhaps you misunderstand crab engineering?

# As it turns out, crab submarine engines don't burn fuel at a constant rate. Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: the first step costs 1, the second step costs 2, the third step costs 3, and so on.

# As each crab moves, moving further becomes more expensive. This changes the best horizontal position to align them all on; in the example above, this becomes 5:

#     Move from 16 to 5: 66 fuel
#     Move from 1 to 5: 10 fuel
#     Move from 2 to 5: 6 fuel
#     Move from 0 to 5: 15 fuel
#     Move from 4 to 5: 1 fuel
#     Move from 2 to 5: 6 fuel
#     Move from 7 to 5: 3 fuel
#     Move from 1 to 5: 10 fuel
#     Move from 2 to 5: 6 fuel
#     Move from 14 to 5: 45 fuel

# This costs a total of 168 fuel. This is the new cheapest possible outcome; the old alignment position (2) now costs 206 fuel instead.

# Determine the horizontal position that the crabs can align to using the least fuel possible so they can make you an escape route! How much fuel must they spend to align to that position?

# Your puzzle answer was 96086265.

# [478, 96086265]

class Crabs
  attr :crabs
  attr :outcomes

  def initialize(lines)
    @outcomes = {}
    @crabs = []
    lines.each do |l|
      @crabs << l.to_i
    end
    @crabs = @crabs.sort
    #print_state
  end

  def median
    mid = @crabs.length / 2
    if mid.even?
      (@crabs[mid] + @crabs[mid+1]) / 2
    else
      @crabs[mid]
    end
  end

  def mode
    h = @crabs.tally
    #puts h.to_s
    h2 = h.max_by {|k,v| v }
    #puts h2.to_s
    h2[0]
  end

  def mean
    @crabs.sum/@crabs.length
  end

  def print_state
    puts @crabs.to_s
  end

  def calc_fuel_constant(pos)
    total = 0
    @crabs.each do |c|
      move = c - pos
      total += move.abs
      # puts "pos #{pos} c=#{c} move=#{move} total=#{total}"
    end
    total
  end

  def calc_fuel_increasing(pos)
    total = 0

    @crabs.each do |c|
      from = [c, pos].min
      to = [c, pos].max
      pctotal = 0
      (from..to).each_with_index do |step, i|
        pctotal += i
        #puts "pos #{pos} c=#{c} step=#{step} i=#{i} move=#{move} pctotal=#{pctotal}"
      end
      total += pctotal
      #puts "pos #{pos} c=#{c} total=#{total}"
    end
    total
  end


  def run_constant()
    min = @crabs[0]
    max = @crabs[-1]
    (min..max).each do |pos|
      used = calc_fuel_constant(pos)
      outcomes[pos] = used
    end
    sol = outcomes.sort_by {|pos, used| used}
    # puts outcomes.to_s
    # puts sol.to_s
    puts sol[0].to_s
  end

  def run_increasing()
    min = @crabs[0]
    max = @crabs[-1]
    (min..max).each do |pos|
      used = calc_fuel_increasing(pos)
      outcomes[pos] = used
    end
    sol = outcomes.sort_by {|pos, used| used}
    # puts outcomes.to_s
    # puts sol.to_s
    puts sol[0].to_s
  end
end

#############################################################################
#
def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = input_data.chomp.split(',')
  puts "input_data: #{lines.length} lines"
  lines
end

def write_output(file_name, output)
  #File.write(file_name, output.join("\n"), mode: 'w')
end

def part1(input_file)
  lines = read_input(input_file)
  c = Crabs.new(lines)

  # seems like if you choose median (+/-1?) you get the right
  # answer. don't need to brute force search.
  puts "median #{c.median}"
  puts "mode #{c.mode}"
  puts "mean #{c.mean}"
  c.run_constant
end

def part2(input_file)
  lines = read_input(input_file)
  c = Crabs.new(lines)

  # seems like if you choose mean (+/-1?) you get the right
  # answer. don't need to brute force search.  
  puts "median #{c.median}"
  puts "mode #{c.mode}"
  puts "mean #{c.mean}"
  c.run_increasing
end

puts ""
puts "part 1 sample"
part1('aoc_07_2021_input_sample.txt')

puts ""
puts "part 1"
part1('aoc_07_2021_input.txt')

puts ""
puts "part 2 sample"
part2('aoc_07_2021_input_sample.txt')

puts ""
puts "part 2"
part2('aoc_07_2021_input.txt')
