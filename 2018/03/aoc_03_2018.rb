#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2018/day/3

# Each Elf has made a claim about which area of fabric would be ideal
# for Santa's suit. All claims have an ID and consist of a single
# rectangle with edges parallel to the edges of the fabric. Each
# claim's rectangle is defined as follows:

# The number of inches between the left edge of the fabric and the left edge of the rectangle.
# The number of inches between the top edge of the fabric and the top edge of the rectangle.
# The width of the rectangle in inches.
# The height of the rectangle in inches.

# A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a
# rectangle 3 inches from the left edge, 2 inches from the top edge, 5
# inches wide, and 4 inches tall. Visually, it claims the square
# inches of fabric represented by # (and ignores the square inches of
# fabric represented by .) in the diagram below:

# ...........
# ...........
# ...#####...
# ...#####...
# ...#####...
# ...#####...
# ...........
# ...........
# ...........

# The problem is that many of the claims overlap, causing two or more
# claims to cover part of the same areas. For example, consider the
# following claims:

# #1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2
# Visually, these claim the following areas:

# ........
# ...2222.
# ...2222.
# .11XX22.
# .11XX22.
# .111133.
# .111133.
# ........

# The four square inches marked with X are claimed by both 1 and
# 2. (Claim 3, while adjacent to the others, does not overlap either
# of them.)

# If the Elves all proceed with their own plans, none of them will
# have enough fabric. How many square inches of fabric are within two
# or more claims?

# 32217 too low


def parse_line(line, hash, max_xy)
  parts = line.split(' ')
  id = parts[0][1..-1]
  x,y = parts[2].sub(':', '').split(',')
  x = x.to_i
  y = y.to_i
  l,w = parts[3].split('x')
  l = l.to_i
  w = w.to_i
  
  x2 = x+l-1
  y2 = y+w-1
  
  hash[id] = {
    'id' => id,
    'overlap' => false,
    'x' => x,
    'y' => y,
    'x2' => x2,
    'y2' => y2,
    'l' => l,
    'w' => w
  }
  #puts "#{line}  id=#{id} x,y=#{x},#{y} #{l}x#{w}  #{x2},#{y2} max #{max_xy['x']},#{max_xy['y']}"
  max_xy['x'] = x2 if x2 > max_xy['x']
  max_xy['y'] = y2 if y2 > max_xy['y']
end

def print_grid(grid)
  total = 0
  grid.each do |row|
    # row.each do |item|
    #   pp item
    # end
    pp row
    row.each do |item|
      if item == 'x'
        total +=1
      end
    end
  end
  return total
end

def count_sq_inches_overlap(grid)
  total = 0
  grid.each do |row|
    row.each do |item|
      if item == 'x'
        total +=1
      end
    end
  end
  return total
end


def read_input(file_name)
  all_inputs = Hash.new
  max_xy = Hash.new
  max_xy['x'] = 0
  max_xy['y'] = 0

  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    parse_line(input, all_inputs, max_xy)
  end
  return all_inputs, max_xy
end

def brute_force(file_name)
  inputs, max_xy = read_input(file_name)
  puts "Max x,y:  #{max_xy}"
  puts "Read #{inputs.length} lines"

  grid = Array.new(max_xy['x']+1) { Array.new(max_xy['y']+1, "0")}

  #print_grid(grid)

  inputs.each do |id, input|
    #puts input
    input['x'].upto(input['x2']) do |i|
      input['y'].upto(input['y2']) do |j|
        #puts "#{i} #{j}"
        if grid[i][j] == "0"
          grid[i][j] = id
        else
          grid[i][j] = 'x'
          input['overlap'] = true
        end
        # print_grid(grid)
        # puts "*"*4
      end
    end
    # print_grid(grid)
    # puts "*"*8
  end

  #total = print_grid(grid)
  total = count_sq_inches_overlap(grid)
  puts "total sq in #{total}"

  puts "*"*20
  puts "Checking first time"
  count = 0
  inputs.each do |id, input|
    if input['overlap'] == false
      #puts "No overlap #{id}"
      count+=1
    end
  end
  puts " #{count} id without overlap after first pass"
  
  puts "*"*20
  puts "Checking second time"
  inputs.each do |id, input|
    next if input['overlap'] == true
    # puts "Check overlap id=#{id}"
    input['x'].upto(input['x2']) do |i|
      input['y'].upto(input['y2']) do |j|
        if grid[i][j] == "x"
          input['overlap'] = true
          #puts "  id=#{id} has overlap"
          break
        end
      end
      break if input['overlap'] == true
    end
  end
  
  inputs.each do |id, input|
    if input['overlap'] == false
      puts "No overlap #{id}"
    end
  end
  
end

#brute_force('sample.txt')

brute_force('aoc_03_2018_input.txt')

