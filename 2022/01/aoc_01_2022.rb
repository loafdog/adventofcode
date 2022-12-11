#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/1

# --- Day 1: Calorie Counting ---
# Santa's reindeer typically eat regular reindeer food, but they need a lot of magical energy to deliver presents on Christmas. For that, their favorite snack is a special type of star fruit that only grows deep in the jungle. The Elves have brought you on their annual expedition to the grove where the fruit grows.

# To supply enough magical energy, the expedition needs to retrieve a minimum of fifty stars by December 25th. Although the Elves assure you that the grove has plenty of fruit, you decide to grab any fruit you see along the way, just in case.

# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

# The jungle must be too overgrown and difficult to navigate in vehicles or access from the air; the Elves' expedition traditionally goes on foot. As your boats approach land, the Elves begin taking inventory of their supplies. One important consideration is food - in particular, the number of Calories each Elf is carrying (your puzzle input).

# The Elves take turns writing down the number of Calories contained by the various meals, snacks, rations, etc. that they've brought with them, one item per line. Each Elf separates their own inventory from the previous Elf's inventory (if any) by a blank line.

# For example, suppose the Elves finish writing their items' Calories and end up with the following list:

# 1000
# 2000
# 3000

# 4000

# 5000
# 6000

# 7000
# 8000
# 9000

# 10000
# This list represents the Calories of the food carried by five Elves:

# The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
# The second Elf is carrying one food item with 4000 Calories.
# The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
# The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
# The fifth Elf is carrying one food item with 10000 Calories.
# In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: they'd like to know how many Calories are being carried by the Elf carrying the most Calories. In the example above, this is 24000 (carried by the fourth Elf).

# Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?


def part1(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = 0
  data = []
  totals = []
  total = 0
  input_data.each_line do |line|
    line.chomp!
    #puts "line=[#{line}]"
    if line.empty?
      totals << total
      total = 0
    else
      i = Integer(line)
      total = total + i
    end
  end
  answer = totals.sort.reverse
  puts "0=#{answer[0]}"
  puts "1=#{answer[1]}"
  puts "2=#{answer[2]}"
  sum = answer[0] + answer[1] + answer[2]
  puts "sum=#{sum}"
end

def write_output(file_name, output)
  File.write(file_name, output.join("\n"), mode: 'w')
end


puts ""
puts "sample"
part1('aoc_01_2022_sample_input.txt')
puts ""
puts "actual"
part1('aoc_01_2022_input.txt')
