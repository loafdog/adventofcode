#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/8

# --- Day 8: Treetop Tree House ---
# The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

# First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

# The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

# 30373
# 25512
# 65332
# 33549
# 35390
# Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

# A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

# All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

# The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
# The top-middle 5 is visible from the top and right.
# The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
# The left-middle 5 is visible, but only from the right.
# The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
# The right-middle 3 is visible from the right.
# In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
# With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

# Consider your map; how many trees are visible from outside the grid?

require 'pry'

class Forest

  attr_accessor :grid
  attr_accessor :trees
  attr_accessor :scenic

  def initialize(grid)
    @grid = grid
    @trees = []
    @trees << Array.new(@grid[0].length, 1)
    1.upto(@grid.length - 2) do |i|
      @trees << Array.new(@grid[i].length, 0)
      @trees[i][0] = 1
      @trees[i][-1] = 1
    end
    @trees << Array.new(@grid[-1].length, 1)

    @scenic = []
    0.upto(@grid.length - 1) do |i|
      @scenic << Array.new(@grid[i].length, 0)
    end
  end

  def print_scenic
    @scenic.each do |r|
      puts r.join(' ')
    end
  end

  def print_trees
    @trees.each do |r|
      puts r.join(' ')
    end
  end

  def print_grid
    @grid.each do |r|
      puts r.join(' ')
    end
  end

  def left_to_right(row, r)
    s = 1
    e = row.length - 2
    max = row[0]
    puts "r=#{r} l>r #{row.join(' ')}"
    s.upto(e) do |i|
      # walk left to right
      puts "#{i} #{row[i-1]} #{row[i]} #{row[i-1] < row[i]}"
      # if row[i-1] < row[i]
      #   @trees[r][i] = 1
      # end
      # if row[i-1] > row[i]
      #   break
      # end
      if row[i] > max
        @trees[r][i] = 1
        max = row[i]
      end
    end
    print_trees
    puts ""
  end

  def right_to_left(row, r)
    s = row.length - 2
    e = 1
    max = row[-1]
    puts "r=#{r} r>l #{row.join(' ')}"
    s.downto(e) do |i|
      # walk right to left
      puts "#{i} #{row[i-1]} #{row[i]} #{row[i-1] < row[i]}"
      # if row[i+1] < row[i]
      #   @trees[r][i] = 1
      # end
      # if row[i+1] > row[i]
      #   break
      # end
      if row[i] > max
        @trees[r][i] = 1
        max = row[i]
      end
    end

    print_trees
    puts ""
  end

  def find_visible
    s = 1
    e = @grid.length - 2
    s.upto(e) do |i|
      left_to_right(@grid[i], i)
      right_to_left(@grid[i], i)
    end

    # print_trees
    # puts ""
    # print_grid
    @grid = @grid.transpose
    @trees = @trees.transpose
    # print_trees
    # puts ""
    # print_grid

    s.upto(e) do |i|
      left_to_right(@grid[i], i)
      right_to_left(@grid[i], i)
    end

    @grid = @grid.transpose
    @trees = @trees.transpose
    print_trees
    puts ""
    print_grid
  end

  def count_visible
    total = 0
    @trees.each do |r|
      total += r.count(1)
    end
    return total
  end


  def count_up(x,y)
    nx = x
    ny = y
    start = @grid[x][y]
    #print_grid

    score = 0
    nx -= 1
    while nx >= 0
      puts "x=#{nx} y=#{ny} #{@grid[nx][ny]}"
      score += 1
      if @grid[nx][ny] < start
        nx -= 1
      else
        break
      end
    end
    puts "count up start at #{x} #{y} start=#{start} score=#{score}"

    score
  end

  def count_down(x,y)
    nx = x
    ny = y
    start = @grid[x][y]
    #print_grid

    score = 0
    nx += 1
    while nx < @grid.length
      puts "x=#{nx} y=#{ny} #{@grid[nx][ny]} start=#{start}"
      score += 1
      if @grid[nx][ny] < start
        nx += 1
      else
        break
      end
    end
    puts "count down start at #{x} #{y} start=#{start} score=#{score}"
    score
  end

  def count_left(x,y)
    nx = x
    ny = y
    start = @grid[x][y]
    #print_grid

    score = 0
    ny -= 1
    while ny >= 0
      puts "x=#{nx} y=#{ny} #{@grid[nx][ny]}"
      score += 1
      if @grid[nx][ny] < start
        ny -= 1
      else
        break
      end
    end
    puts "count left start at #{x} #{y} start=#{start} score=#{score}"
    score
  end

  def count_right(x,y)
    nx = x
    ny = y
    start = @grid[x][y]
    #print_grid

    score = 0
    ny += 1
    while ny < @grid[x].length
      puts "x=#{nx} y=#{ny} #{@grid[nx][ny]}"
      score += 1
      if @grid[nx][ny] < start
        ny += 1
      else
        break
      end
    end
    puts "count right start at #{x} #{y} start=#{start} score=#{score}"
    score
  end


  def calc_scenic_scores
    # start at 0,0?
    # move in each dir, up, down, left, right
    # if next spot is < start height keep going, add to count
    # if next spot is >= then stop, include this in count
    # keep track of count for each dir sep
    # multiply all 4 counts and set score for that spot

    # Note.. instead of 4 funcs to move each dir.. could have done
    # what did for part 1.. move left/right or only right.. and rotate
    # the array to calc score for each dir?

    sx = 1
    ex = @grid.length - 2
    sx.upto(ex) do |x|
      row = @grid[x]
      sy = 1
      ey = row.length-2

      sy.upto(ey) do |y|
        rc = lc = dc = uc = 1
        rc = count_right(x,y)
        lc = count_left(x,y)
        dc = count_down(x,y)
        uc = count_up(x,y)
        score = rc * lc * dc * uc
        puts "rc * lc * dc * uc: #{rc} * #{lc} * #{dc} * #{uc} score=#{score}"

        @scenic[x][y] = score
        #print_scenic
        puts ""
      end
    end
  end


  def find_max_scenic_score
    max = 0
    @scenic.each do |row|
      rmax = row.max
      if rmax > max
        max = rmax
      end
    end
    max
  end


end

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read

  rows = []
  input_data.each_line do |line|
    line.chomp!
    rows << line.chars.map {|c| c.to_i}
  end
  return rows
end

rows = read_input('aoc_08_2022_sample_input.txt')
f = Forest.new(rows)
f.find_visible
puts f.count_visible
f.calc_scenic_scores
puts f.find_max_scenic_score



rows = read_input('aoc_08_2022_input.txt')
f = Forest.new(rows)
f.find_visible
puts f.count_visible
f.calc_scenic_scores
puts f.find_max_scenic_score
