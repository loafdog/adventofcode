#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2021/day/6

# --- Day 6: Lanternfish ---

# The sea floor is getting steeper. Maybe the sleigh keys got carried this way?

# A massive school of glowing lanternfish swims past. They must spawn quickly to reach such large numbers - maybe exponentially quickly? You should model their growth rate to be sure.

# Although you know nothing about this specific species of lanternfish, you make some guesses about their attributes. Surely, each lanternfish creates a new lanternfish once every 7 days.

# However, this process isn't necessarily synchronized between every lanternfish - one lanternfish might have 2 days left until it creates another lanternfish, while another might have 4. So, you can model each fish as a single number that represents the number of days until it creates a new lanternfish.

# Furthermore, you reason, a new lanternfish would surely need slightly longer before it's capable of producing more lanternfish: two more days for its first cycle.

# So, suppose you have a lanternfish with an internal timer value of 3:

#     After one day, its internal timer would become 2.
#     After another day, its internal timer would become 1.
#     After another day, its internal timer would become 0.
#     After another day, its internal timer would reset to 6, and it would create a new lanternfish with an internal timer of 8.
#     After another day, the first lanternfish would have an internal timer of 5, and the second lanternfish would have an internal timer of 7.

# A lanternfish that creates a new fish resets its timer to 6, not 7 (because 0 is included as a valid timer value). The new lanternfish starts with an internal timer of 8 and does not start counting down until the next day.

# Realizing what you're trying to do, the submarine automatically produces a list of the ages of several hundred nearby lanternfish (your puzzle input). For example, suppose you were given the following list:

# 3,4,3,1,2

# This list means that the first fish has an internal timer of 3, the second fish has an internal timer of 4, and so on until the fifth fish, which has an internal timer of 2. Simulating these fish over several days would proceed as follows:

# Initial state: 3,4,3,1,2
# After  1 day:  2,3,2,0,1
# After  2 days: 1,2,1,6,0,8
# After  3 days: 0,1,0,5,6,7,8
# After  4 days: 6,0,6,4,5,6,7,8,8
# After  5 days: 5,6,5,3,4,5,6,7,7,8
# After  6 days: 4,5,4,2,3,4,5,6,6,7
# After  7 days: 3,4,3,1,2,3,4,5,5,6
# After  8 days: 2,3,2,0,1,2,3,4,4,5
# After  9 days: 1,2,1,6,0,1,2,3,3,4,8
# After 10 days: 0,1,0,5,6,0,1,2,2,3,7,8
# After 11 days: 6,0,6,4,5,6,0,1,1,2,6,7,8,8,8
# After 12 days: 5,6,5,3,4,5,6,0,0,1,5,6,7,7,7,8,8
# After 13 days: 4,5,4,2,3,4,5,6,6,0,4,5,6,6,6,7,7,8,8
# After 14 days: 3,4,3,1,2,3,4,5,5,6,3,4,5,5,5,6,6,7,7,8
# After 15 days: 2,3,2,0,1,2,3,4,4,5,2,3,4,4,4,5,5,6,6,7
# After 16 days: 1,2,1,6,0,1,2,3,3,4,1,2,3,3,3,4,4,5,5,6,8
# After 17 days: 0,1,0,5,6,0,1,2,2,3,0,1,2,2,2,3,3,4,4,5,7,8
# After 18 days: 6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8

# Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other number decreases by 1 if it was present at the start of the day.

# In this example, after 18 days, there are a total of 26 fish. After 80 days, there would be a total of 5934.

# Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?

class CounterNaive
  attr :start
  attr_accessor :cur

  def initialize(start)
    @start = start.to_i
    @cur = start.to_i
  end

  def next_day
    case @cur
    when 0
      @cur = 6
      return true
    else
      @cur = @cur - 1
    end
    false
  end
  
end

class LanternFishNaive
  attr :lines
  attr :fish
  attr :day
  attr :days
  
  def initialize(lines, days)
    @fish = []
    lines.each do |line|
      @fish << CounterNaive.new(line)
    end
    @days = days
    @day = 0
  end

  def print_state
    state = []
    @fish.each do |f|
      state << f.cur
    end
    str = state.join(',')
    puts "day #{@day}: " + str
  end

  def next_day
    spawns = 0
    @fish.each do |f|
      if f.next_day
        spawns += 1
      end
    end
    @day += 1
    (1..spawns).each do |i|
      @fish << CounterNaive.new(8)
    end
    #print_state
  end

  def run
    (0..@days-1).each do |d|
      next_day
    end
    puts "NAIVE: after #{@days} days there are #{@fish.length} fish"
  end
  
end

# Probably overkill to declare a class when the array class pretty
# much does what we need.  Oh well...
class FIFO
  attr_reader :size, :arr

  def self.[](*values)
    obj = self.new(values.size)
    obj.arr = values
    obj
  end

  def initialize(size)
    @size = size
    @arr  = Array.new
  end

  def length
    arr.length
  end

  def to_s
    arr.to_s
  end

  def push(element)
    arr.push(element)
    arr.shift if arr.length > size
    arr
  end

  def pop
    arr.shift
  end

  def peek
    arr[0]
  end

  def sum
    total = 0
    arr.each do |v|
      total += v
    end
    total
  end
end



class LanternFish
  attr :lines
  attr :days  
  attr :fifo
  
  def initialize(lines, days)

    puts "days=#{days}"
    #puts "lines=#{lines}"

    day_counters = Array.new(9, 0)
    lines.each do |line|
      day_counters[line.to_i] += 1
    end
    
    @fifo = FIFO.new(9)
    day_counters.each do |d|
      @fifo.push(d)
    end
    @days = days
    print_state
  end

  def print_state
    puts "fifo size=#{@fifo.size} len=#{@fifo.length}  #{fifo.to_s}"    
  end

  def next_day
    # elem is number of fish at the number day.  when we pop the fifo
    # we get number of fish at zero.  That indicates how many new fish
    # spawn at 8 day counter.  Then that same number goes back to 6
    # day counter.
    elem = @fifo.pop
    @fifo.push(elem)
    @fifo.arr[6] += elem
    #print_state
  end

  def run
    (0..@days-1).each do |d|
      next_day
    end
    puts "FIFO: after #{@days} days there are #{@fifo.sum} fish"  end
  
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
  puts "="*40  
  lf = LanternFishNaive.new(lines, 18)
  lf.run
  lf = LanternFish.new(lines, 18)
  lf.run
  puts "="*20
  lf = LanternFishNaive.new(lines, 80)
  lf.run
  lf = LanternFish.new(lines, 80)
  lf.run
  
end

def part2(input_file)
  # don't even try naive solution.  i killed my run/attempt after 15m
  # or so of running w.o solution.  It used up lots of memory.
  
  lines = read_input(input_file)
  lf = LanternFish.new(lines, 256)
  lf.run
end

puts ""
puts "part 1 sample"
part1('aoc_06_2021_input_sample.txt')

puts ""
puts "part 1"
part1('aoc_06_2021_input.txt')

puts ""
puts "part 2 sample"
part2('aoc_06_2021_input_sample.txt')

puts ""
puts "part 2"
part2('aoc_06_2021_input.txt')
