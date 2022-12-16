#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/5

# --- Day 5: Supply Stacks ---
# The expedition can depart as soon as the final supplies have been unloaded from the ships. Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates, the crates need to be rearranged.

# The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the top of each stack.

# The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

# They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

#     [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3

# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2
# In this example, there are three stacks of crates. Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains three crates; from bottom to top, they are crates M, C, and D. Finally, stack 3 contains a single crate, P.

# Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1, resulting in this configuration:

# [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3
# In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

#         [Z]
#         [N]
#     [C] [D]
#     [M] [P]
#  1   2   3
# Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

#         [Z]
#         [N]
# [M]     [D]
# [C]     [P]
#  1   2   3
# Finally, one crate is moved from stack 1 to stack 2:

#         [Z]
#         [N]
#         [D]
# [C] [M] [P]
#  1   2   3
# The Elves just need to know which crate will end up on top of each stack; in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine these together and give the Elves the message CMZ.

# After the rearrangement procedure completes, what crate ends up on top of each stack?

require 'pry'

def part1(file_name)
  stacks = []

  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    line.chomp!
    if line.include?('[')
      puts line

      offs = []
      offset = -1
      loop do
        offset = line.index('[', offset+1)

        break if offset.nil?

        crate = line[offset+1]
        s_index = offset/4
        puts "#{offset} #{s_index} #{crate}"
        if stacks[s_index].nil?
          stacks[s_index] = []
        end
        stacks[s_index].insert(0, crate)
      end
    end

    if line.include?('move')
      puts "Current stacks:"
      stacks.each do |s|
        puts s.join(' ')
      end

      parts = line.split(' ')
      amount = parts[1].to_i
      start = parts[3].to_i - 1
      dest = parts[5].to_i - 1

      puts "move #{amount} crates from #{start} #{stacks[start]} to #{dest} #{stacks[dest]}"
      for s in 1..amount do
        crate = stacks[start].pop
        stacks[dest].push(crate)
      end
    end

  end

  answer = []
  puts "Final stacks"
  stacks.each do |s|
    puts s.join(' ')
    answer << s[-1]
  end
  puts "Answer [#{answer.join}]"

end

def part2(file_name)
  stacks = []

  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    line.chomp!
    if line.include?('[')
      puts line

      offs = []
      offset = -1
      loop do
        offset = line.index('[', offset+1)

        break if offset.nil?

        crate = line[offset+1]
        s_index = offset/4
        puts "#{offset} #{s_index} #{crate}"
        if stacks[s_index].nil?
          stacks[s_index] = []
        end
        stacks[s_index].insert(0, crate)
      end
    end

    if line.include?('move')
      puts "Current stacks:"
      stacks.each do |s|
        puts s.join(' ')
      end

      parts = line.split(' ')
      amount = parts[1].to_i
      start = parts[3].to_i - 1
      dest = parts[5].to_i - 1

      puts "move #{amount} crates from #{start} #{stacks[start]} to #{dest} #{stacks[dest]}"
      crates = stacks[start].pop(amount)
      stacks[dest].push(crates)
      stacks[dest].flatten!
    end
  end

  answer = []
  puts "Final stacks"
  stacks.each do |s|
    puts s.join(' ')
    answer << s[-1]
  end
  puts "Answer [#{answer.join}]"

end

part1('aoc_05_2022_sample_input.txt')

puts "="*80

part1('aoc_05_2022_input.txt')


part2('aoc_05_2022_sample_input.txt')

puts "="*80

part2('aoc_05_2022_input.txt')
