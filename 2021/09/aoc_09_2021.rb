#!/usr/bin/env ruby
require 'pry'
require 'set'

# https://adventofcode.com/2021/day/9

# --- Day 9: Smoke Basin ---

# These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

# If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

# Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678

# Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

# Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

# In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

# The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

# Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

# Your puzzle answer was 448.

# --- Part Two ---

# Next, you need to find the largest basins so you know what areas are most important to avoid.

# A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

# The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

# The top-left basin, size 3:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678

# The top-right basin, size 9:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678

# The middle basin, size 14:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678

# The bottom-right basin, size 9:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678

# Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

# What do you get if you multiply together the sizes of the three largest basins?

# Your puzzle answer was 1417248.


# NOTE to self
#
# Got part1 fine.  Part2 took 3 tries.  First try was a bad version of
# traversal algo, like BFS?  Did not take into account alread visited
# nodes.  Second try was attempt to traverse the map cell by cell and
# check neighbors to see what action to take.  This worked for the
# sample but failed to work on the real input.  I gave up trying to
# figure it out because debugging the huge puzzle input was just not
# worth it.  I figured I'd end up with lots of if stmts to check
# corner cases.  I looked at the solutions thread at this point and
# found suggestion to look at
# https://www.redblobgames.com/pathfinding/a-star/introduction.html
# The BFS described here is what got me to solve it.
#
#

class Map
  attr :map
  attr :basin_map
  attr :row_max, :col_max
  attr :min_points
  attr :total
  attr :basins
  

  def initialize(lines)
    @map = Array.new(lines.length)
    @basin_map = Array.new(lines.length)
    lines.each_with_index do |line, i|
      #@map[i] = line.chomp.chars
      @map[i] = line.chomp.each_char.map { |c| Integer(c) }
      @basin_map[i] = Array.new(@map[i].length, '.')
    end
    @row_max = @map.length
    @col_max = @map[0].length
    puts "row_max=#{@row_max} col_max=#{@col_max}"
    print_basin_map
    @min_points = []
    @total = 0
    @basins = []
  end

  def print
    @map.each do |row|
      puts row.join
    end
  end

  def print_basin_map
    @basin_map.each do |row|
      puts row.join('')
    end
  end


  def find_mins
    @map.each_with_index do |row, i|
      row.each_with_index do |pt, j|
        min = 0
        gr = false        
        if i-1 >= 0
          if @map[i][j] < @map[i-1][j]
            min += 1
          else
            gr = true
          end
          # puts "   i=#{i-1} j=#{j} @map[#{i-1}][#{j}]=#{@map[i-1][j]}"
        end
        if j-1 >= 0
          if @map[i][j] < @map[i][j-1]
            min = min += 1
          else
            gr = true
          end
          # puts "   i=#{i} j=#{j-1} @map[#{i}][#{j-1}]=#{@map[i][j-1]}"
        end
        if i+1 < @row_max
          if @map[i][j] < @map[i+1][j]
            min = min += 1
          else
            gr = true
          end
          # puts "   i=#{i+1} j=#{j} @map[#{i+1}][#{j}]=#{@map[i+1][j]}"
        end
        if j+1 < @col_max
          if @map[i][j] < @map[i][j+1]
            min = min += 1
          else
            gr = true
          end
          # puts "   i=#{i} j=#{j+1} @map[#{i}][#{j+1}]=#{@map[i][j+1]}"          
        end
        # puts "AT i=#{i} j=#{j} pt=#{pt} gr=#{gr} min=#{min}"
        if gr == false
          puts "FOUND min pt i=#{i} j=#{j} pt=#{pt} gr=#{gr} min=#{min}"
          @min_points << [i,j]
          @total += 1 + pt.to_i
        end
      end
    end
    puts "Found #{@min_points.length} min points"
    puts "risk level = #{@total}"
  end

  # def travel_left(pt)
  #   count = 0
  #   i = pt[0]
  #   pt[1].downto(0).each do |j|
  #     puts "t left: pt=#{pt} i=#{i} j=#{j} #{@map[i][j]}"
  #     if @map[i][j] == 9 || @basin_map[i][j] != '.'
  #       break
  #     end
  #     count += 1
  #     @basin_map[i][j] = @map[i][j]
  #     count += travel_up([i,j])
  #     count += travel_down([i,j])
  #   end
  #   count -= 1
  #   if count < 0
  #     count = 0
  #   end
  #   puts "t left: pt=#{pt} count=#{count}"
  #   count
  # end

  # def travel_right(pt)
  #   count = 0
  #   i = pt[0]
  #   pt[1].upto(@row_max).each do |j|
  #     puts "t right: i=#{i} j=#{j} #{@map[i][j]}"
  #     if @map[i][j] == 9 || @basin_map[i][j] != '.'
  #       break
  #     end
  #     count += 1
  #     @basin_map[i][j] = @map[i][j]      
  #     count += travel_up([i,j])
  #     count += travel_down([i,j])      
  #   end
  #   count -= 1
  #   if count < 0
  #     count = 0
  #   end    
  #   puts "t right: pt=#{pt} count=#{count}"
  #   count
  # end

  # def travel_up(pt)
  #   count = 0
  #   j = pt[0]
  #   pt[0].downto(0).each do |i|
  #     puts "t up: i=#{i} j=#{j} #{@map[i][j]}"
  #     if @map[i][j] == 9 || @basin_map[i][j] != '.'
  #       break
  #     end
  #     count += 1
  #     @basin_map[i][j] = @map[i][j]      
  #   end
  #   count -= 1
  #   if count < 0
  #     count = 0
  #   end    
  #   puts "t up: pt=#{pt} count=#{count}"
  #   count
  # end

  # def travel_down(pt)
  #   count = 0
  #   j = pt[0]
  #   pt[0].upto(@col_max).each do |i|
  #     puts "t down: i=#{i} j=#{j} #{@map[i][j]}"
  #     if @map[i][j] == 9 || @basin_map[i][j] != '.'
  #       break
  #     end
  #     count += 1
  #     @basin_map[i][j] = @map[i][j]
  #   end
  #   count -= 1
  #   if count < 0
  #     count = 0
  #   end    
  #   puts "t down: pt=#{pt} count=#{count}"
  #   count
  # end

  # def find_basins

  #   @min_points.each do |mpt|
  #     size = 1
  #     size += travel_left(mpt)
  #     size += travel_right(mpt)
  #     size += travel_up(mpt)
  #     size += travel_down(mpt)
  #     @basins << size
  #     puts "mpt=#{mpt} size=#{size}"
  #     puts ""
  #   end
  #   @basins.sort!.reverse!
  #   puts "top3 #{@basins[0..2].to_s}"
  #   total = @basins[0] 
  #   @basins[1..2].each do |s|
  #     total *= s
  #   end
  #   print_basin_map
  #   puts total
  # end


  # def up(i,j)
  #   if @basin_map[i-1][j] != 0
  #     @basin_map[i-1][j]
  #   else
  #     '.'
  #   end
  # end

  # def down(i,j)
  #   if i+1 < @row_max
  #     @basin_map[i+1][j]
  #   else
  #     '.'
  #   end
  # end
  
  # def right(i,j)
  #   if j+1 < @col_max
  #     @basin_map[i][j+1]
  #   else
  #     '.'
  #   end
  # end

  # def left(i,j)
  #   if j-1 >= 0
  #     @basin_map[i][j-1]
  #   else
  #     '.'
  #   end
  # end

  # def diag_down_right(i,j)
  #   if j+1 < @col_max && i+1 < @row_max
  #     @basin_map[i+1][j+1]
  #   else
  #     '.'
  #   end
  # end

  # def mark_right(i,j, mark)
  #   if j+1 < @col_max && @basin_map[i][j+1] != '.'
  #     @basin_map[i][j+1] = mark
  #   end
  # end
  
  # def mark_down(i,j, mark)
  #   #puts "mark_down: [#{i} #{j}] mark=#{mark} @col_max=#{@col_max}"
  #   if i+1 < @row_max && @basin_map[i+1][j] != '.'
  #     @basin_map[i+1][j] = mark
  #   end    
  # end

  # def find_basins_2
  #   @map.each_with_index do |row, i|
  #     row.each_with_index do |pt, j|
  #       if @map[i][j] != 9
  #         #@basin_map[i][j] = @map[i][j]
  #         @basin_map[i][j] = 0
  #       end
  #     end
  #   end
  #   print_basin_map
  #   puts ""
  #   @basin_map.each_with_index do |row, i|
  #     row.each_with_index do |pt, j|
  #       if @basin_map[i][j] == '.'
  #         # don't change current mark/val in map
  #         # check if down/right have values
  #         # set down
  #         l = left(i,j)
  #         r = right(i,j)
  #         u = up(i,j)
  #         d = down(i,j)
  #         dr = diag_down_right(i,j)
  #         puts "[#{i} #{j}]='.' r=#{r} d=#{d}"
  #         if r == 0 && d == 0 && dr != '.'
  #           # new basin
  #           @basins << 0
  #           mark = @basins.length
  #           mark_right(i,j,mark)
  #           mark_down(i,j,mark)
  #           puts "[#{i} #{j}]='.' r=#{r} d=#{d} mark=#{mark} right/down new basin"
  #         elsif r != '.' && d == 0 && dr != '.'
  #           puts "[#{i} #{j}]='.' r=#{r} d=#{d} mark=#{r} down"
  #           mark_down(i,j,r)
  #         end
  #       elsif @basin_map[i][j] != 0
  #         mark = @basin_map[i][j]
  #         puts "[#{i} #{j}]=#{mark} mark #{mark} right/down"
  #         mark_right(i,j,mark)
  #         mark_down(i,j,mark)
  #       elsif @basin_map[i][j] == 0
  #         # if cell above is non-zero mark this cell same as above
  #         # if cell below is non-zero mark this cell same as above, don't need this?
  #         # if cell to right is non-zero mark this same same as right
  #         # if cell above/right zero mark mark this as a new basin
  #         u = up(i,j)
  #         r = right(i,j)
  #         l = left(i,j)
  #         puts "[#{i} #{j}] up=#{u} left=#{l} right=#{r} basins=#{basins.length}"
  #         if l == '.' && u == '.'
  #           # new basin
  #           @basins << 0
  #           mark = @basins.length
  #           @basin_map[i][j] = mark
  #           mark_right(i,j,mark)
  #           mark_down(i,j,mark)
  #           puts "[#{i} #{j}]=#{@basin_map[i][j]} r=#{r} d=#{d} mark=#{mark} right/down new basin"
  #         # else
  #         #   mark_right(i,j,mark)
  #         #   mark_down(i,j,mark)
  #         # elsif mark_left != '.'
  #         #   @basin_map[i][j] = mark_left
  #         # elsif mark_up != '.'
  #         #   @basin_map[i][j] = mark_up

  #         end

  #         # if mark_right == 0
  #         #   # new basin
  #         #   @basins << 0
  #         #   mark = @basins.length
  #         # end
  #         # @basin_map[i][j] = mark
  #       end
  #     end
  #   end
  #   print_basin_map
  #   totals = {}
  #   @basin_map.each_with_index do |row, i|
  #     tots = row.tally
  #     #binding.pry
  #     totals.merge!(tots) {|key, old_val, new_val| old_val + new_val}
  #     #puts "row=#{i} #{tots}"
  #     #puts "  totals=#{totals}"
  #   end
  #   totals.delete('.')
  #   top3 = totals.values.sort.reverse[0..2]
  #   answer = top3[0] * top3[1] * top3[2]
  #   puts "TOTALS=#{top3} answer=#{answer}"
  # end

  
  def neighbors(pt)
    #dirs = [[-1, 0],[0,-1], [1,0], [0,1]]
    arr = []
    # up
    if pt[0]-1 >= 0
      arr << [pt[0]-1, pt[1]]
    end
    # down
    if pt[0]+1 < @row_max
      arr << [pt[0]+1, pt[1]]
    end
    # left
    if pt[1]-1 >= 0
      arr << [pt[0], pt[1]-1]
    end
    # right
    if pt[1]+1 < @col_max
      arr << [pt[0], pt[1]+1]
    end

    # remove any neighbor that is a high point(9). I used '.' to mark
    # highpoints
    result = []
    arr.each do |a|
      if @basin_map[a[0]][a[1]] != '.'
        result << a
      end
    end
    result
  end

  def find_basins_3
    @map.each_with_index do |row, i|
      row.each_with_index do |pt, j|
        if @map[i][j] != 9
          @basin_map[i][j] = 0
        end
      end
    end    
    print_basin_map
    puts ""
    
    queue = Queue.new
    reached = Set.new
    basins = []
    @min_points.each do |mpt|
      queue.push(mpt)
      basins << 1
      @basin_map[mpt[0]][mpt[1]] = basins.length
    end

    while not queue.empty? do
      cur = queue.pop
      #puts "cur pt=#{cur}"
      neighbors(cur).each do |pt|
        if not reached.include?(pt)
          queue.push(pt)
          @basin_map[pt[0]][pt[1]] = @basin_map[cur[0]][cur[1]]
          reached.add(pt)
          # print_basin_map
          # puts ""
        end
      end
    end

    print_basin_map

    totals = {}
    @basin_map.each_with_index do |row, i|
      tots = row.tally
      # merge running total with current row totals/tally
      totals.merge!(tots) {|key, old_val, new_val| old_val + new_val}
      #puts "row=#{i} #{tots}"
      #puts "  totals=#{totals}"
    end
    # remove the '.'/9 highpoints
    totals.delete('.')
    top3 = totals.values.sort.reverse[0..2]
    answer = top3[0] * top3[1] * top3[2]
    puts "TOTALS=#{top3} answer=#{answer}"

    # [114, 112, 111]
    # Product of the three largest basin sizes: 1417248    
    
  end

  
end

#############################################################################
#
def read_input(file_name)
  file = File.open(file_name)
  lines = file.readlines
  puts "input_data: #{lines.length} lines"
  lines
end

def write_output(file_name, output)
  #File.write(file_name, output.join("\n"), mode: 'w')
end

def part1(input_file)
  lines = read_input(input_file)
  m = Map.new(lines)
  m.print
  m.find_mins
  m
end

def part2(input_file, m)
  #lines = read_input(input_file)
  #m.find_basins_2
  m.find_basins_3
end

puts ""
puts "part 1 sample"
m = part1('aoc_09_2021_input_sample.txt')

puts ""
puts "part 2 sample"
part2('aoc_09_2021_input_sample.txt', m)

puts ""
puts "part 1"
m = part1('aoc_09_2021_input.txt')

puts ""
puts "part 2"
part2('aoc_09_2021_input.txt', m)
