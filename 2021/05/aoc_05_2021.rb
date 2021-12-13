#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2021/day/5

# --- Day 5: Hydrothermal Venture ---

# You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

# They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

# 0,9 -> 5,9
# 8,0 -> 0,8
# 9,4 -> 3,4
# 2,2 -> 2,1
# 7,0 -> 7,4
# 6,4 -> 2,0
# 0,9 -> 2,9
# 3,4 -> 1,4
# 0,0 -> 8,8
# 5,5 -> 8,2

# Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:

#     An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
#     An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.

# For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

# So, the horizontal and vertical lines from the above list would produce the following diagram:

# .......1..
# ..1....1..
# ..1....1..
# .......1..
# .112111211
# ..........
# ..........
# ..........
# ..........
# 222111....

# In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

# To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

# Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

class Grid
  attr :lines
  attr :x_max, :y_max
  #  attr_accessor :first_board_wins
  attr :grid
  attr :cross_points
  attr :ignore_diag

  def initialize(lines)
    @lines = lines
    @lines.each do |l|
      puts l
    end
    find_max_x_y
    puts "x_max=#{@x_max} y_max=#{@y_max}"
    @grid = Array.new(@x_max + 1)
    puts "@grid.length=#{@grid.length}"
    @grid.each_with_index do |g, i|
      @grid[i] = Array.new(@y_max + 1, '.')
    end
    @cross_points = 0
    @ignore_diag = true
  end

  def map_vents(ignore_diag)
    @ignore_diag = ignore_diag
    print_grid
    mark_lines
    print_grid
    count_cross_points
    puts "cross_points #{@cross_points}"
  end

  def find_max_x_y
    @x_max = 0
    @y_max = 0
    @lines.each do |l|
      mx = [l.x1, l.x2].max
      @x_max = [@x_max, mx].max

      my = [l.y1, l.y2].max
      @y_max = [@y_max, my].max
    end
    # todo add 1 to x,y max?
    # @x_max += 1
    # @y_max += 1
  end

  def print_grid
    return if @x_max > 20
    row = '  '
    (0..@x_max).each do |x|
      row += x.to_s
    end
    puts row
    @grid.each_with_index do |g1, x|
      row = ''
      g1.each_with_index do |g2, y|
        row += @grid[x][y]
      end
      puts x.to_s+ ' ' +row
    end
  end

  def count_cross_points
    cross = 0
    @grid.each_with_index do |g1, x|
      g1.each_with_index do |g2, y|
        if @grid[x][y] != '.' && @grid[x][y].to_i > 1
          cross += 1
        end
      end
    end
    puts "cross=#{cross}"
  end

  def mark_lines()
    @lines.each do |l|
      fill_in_line(l)
      # if l.horizontal? || l.vertical?
      #   #puts "marking x1=#{l.x1} y1=#{l.y1}  x2=#{l.x2} y2=#{l.y2}"
      #   #puts "marking #{l}"
      #   # @grid[l.x1][l.y1] = '1'
      #   # @grid[l.x2][l.y2] = '1'
      #   fill_in_line(l)
      # else
      #   puts "#{l} is not horizontal or vertical"
      # end
    end
  end

  def mark_point(y, x)
    if @grid[y][x] == '.'
      puts "#{x} #{y} = #{@grid[x][y]} -> 1"
      @grid[y][x] = '1'
    else
      if @grid[y][x].to_i == 1
        @cross_points += 1
      end
      v = @grid[y][x].to_i
      v += 1
      puts "#{x} #{y} = #{@grid[x][y]} -> #{v}"
      @grid[y][x] = v.to_s
    end

  end

  def fill_in_line(l)

    if l.horizontal?
      puts "marking horizontal #{l}"
      x1,y = l.start
      x2,y = l.end
      (x1..x2).each do |x|
        mark_point(y, x)
        # if @grid[y][x] == '.'
        #   puts "#{x} #{y} = #{@grid[x][y]} -> 1"
        #   @grid[y][x] = '1'
        # else
        #   if @grid[y][x].to_i == 1
        #     @cross_points += 1
        #   end
        #   v = @grid[y][x].to_i
        #   v += 1
        #   puts "#{x} #{y} = #{@grid[x][y]} -> #{v}"
        #   @grid[y][x] = v.to_s
        # end
      end
      print_grid

    elsif l.vertical?
      puts "marking vertical #{l}"
      x,y1 = l.start
      x,y2 = l.end
      (y1..y2).each do |y|
        mark_point(y, x)
        # if @grid[y][x] == '.'
        #   puts "#{x} #{y} = #{@grid[x][y]} -> 1"
        #   @grid[y][x] = '1'
        # else
        #   if @grid[y][x].to_i == 1
        #     @cross_points += 1
        #   end
        #   v = @grid[y][x].to_i
        #   v += 1
        #   puts "#{x} #{y} = #{@grid[x][y]} -> #{v}"
        #   @grid[y][x] = v.to_s
        # end
      end
      print_grid

    else
      return if @ignore_diag
      puts "marking diagonal #{l}"
      x1,y1 = l.start
      x2,y2 = l.end
      # which way are we going, down left or up right
      if x1 < x2 && y1 < y2
        y = y1
        (x1..x2).each do |x|

          mark_point(y, x)
          y += 1
        end
      else
        y = y1
        (x1..x2).each do |x|
          mark_point(y, x)
          y -= 1
        end
      end
      print_grid

    end
  end

end

class Line

  attr_accessor :x1,:x2,:y1,:y2

  def initialize(input_line)
    first,last = input_line.gsub(' ', '').split('->')
    x1,y1 = first.split(',')
    x2,y2 = last.split(',')

    @x1 = x1.to_i
    @y1 = y1.to_i
    @x2 = x2.to_i
    @y2 = y2.to_i
  end

  def horizontal?
    # 1,1 2,1 3,1
    #
    # y stays same
    #
    # ....
    # .111.
    # ....
    # ....
    #
    @y1 == @y2
  end

  def vertical?
    # 1,1 1,2 1,3
    #
    # x stays same
    #
    # ....
    # .1..
    # .1..
    # .1..
    #
    @x1 == @x2
  end

  def start
    if horizontal?
      x = [@x1, @x2].min
      y = y1
      puts "start horizontal #{x} #{y}"
    elsif vertical?
      x = @x1
      y = [@y1,@y2].min
      puts "start vertical #{x} #{y}"
    else
      if (@x1 < @x2 && @y1 < @y2) || (@x1 >= @x2 && @y1 >= @y2)
        # diag line going top left to bot right
        x = [@x1,@x2].min
        y = [@y1,@y2].min
      else
        x = [@x1,@x2].min
        y = [@y1,@y2].max
      end
      puts "start diagonal #{x} #{y}"
    end
    return x,y
  end

  def end
    if horizontal?
      x = [@x1, @x2].max
      y = @y1
      puts "end horizontal #{x} #{y}"
    elsif vertical?
      x = @x1
      y = [@y1,@y2].max
      puts "end vertical #{x} #{y}"
    else
      if (@x1 < @x2 && @y1 < @y2) || (@x1 >= @x2 && @y1 >= @y2)
        # diag line going top left to bot right
        x = [@x1,@x2].max
        y = [@y1,@y2].max
      else
        x = [@x1,@x2].max
        y = [@y1,@y2].min
      end
      puts "end diagonal #{x} #{y}"
    end
    return x,y
  end

  def to_s
    "#{@x1} #{@y1} -> #{@x2} #{@y2}"
  end

end

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  lines = []
  input_data.each_line do |line|
    l = Line.new(line.chomp!)
    lines << l
    puts "line=#{line} Line=#{l}"
  end
  puts "input_data: #{lines.length} lines"
  g = Grid.new(lines)
  g
end

def write_output(file_name, output)
  #File.write(file_name, output.join("\n"), mode: 'w')
end

def part1(input_file)
  grid = read_input(input_file)
  ignore_diag = true
  grid.map_vents(ignore_diag)
end

def part2(input_file)
  grid = read_input(input_file)
  ignore_diag = false
  grid.map_vents(ignore_diag)
end

puts ""
puts "part 1 sample"
part1('aoc_05_2021_input_sample.txt')

puts ""
puts "part 1"
part1('aoc_05_2021_input.txt')

puts ""
puts "part 2 sample"
part2('aoc_05_2021_input_sample.txt')

puts ""
puts "part 2"
part2('aoc_05_2021_input.txt')
