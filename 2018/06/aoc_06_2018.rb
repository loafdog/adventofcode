#!/usr/bin/env ruby
require 'pry'

# The device on your wrist beeps several times, and once again you feel like you're falling.

# "Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

# The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

# If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

# Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

# Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:

# 1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
# If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:

# ..........
# .A........
# ..........
# ........C.
# ...D......
# .....E....
# .B........
# ..........
# ..........
# ........F.
# This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:

# aaaaa.cccc
# aAaaa.cccc
# aaaddecccc
# aadddeccCc
# ..dDdeeccc
# bb.deEeecc
# bBb.eeee..
# bbb.eeefff
# bbb.eeffff
# bbb.ffffFf
# Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.

# In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.

# What is the size of the largest area that isn't infinite?

# 5390 first guess was too high

# 3687 is the correct answer.  It turns out to be 4th or 5th in my
# list. I used someone else's working program to get answer.  I'm not
# sure what is wrong with my program.  Works on small sample but
# breaks on big example. I give up for now... 

def bad_find_corners(all_inputs, min_max)
  puts "#{__method__}:: "

  x_sort = all_inputs.sort_by {|_key, value| value['x']}
  y_sort = all_inputs.sort_by {|_key, value| value['y']}

  min_max['x_min'] = x_sort[0][1]['x']
  min_max['x_max'] = x_sort[-1][1]['x']
  min_max['y_min'] = y_sort[0][1]['y']
  min_max['y_max'] = y_sort[-1][1]['y']
  pp min_max

  #tr = (x - point['x']).abs + (y - point['y']).abs
  tl = min_max['y_max'] + min_max['x_max']
  tl_label = ''
  x = 0
  y = 0
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < tl
      tl = d
      tl_label = label
    end
  end

  bl = min_max['y_max'] + min_max['x_max']
  bl_label = ''
  x = 0
  y = min_max['y_max']
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < bl
      bl = d
      bl_label = label
    end
  end

  tr = min_max['y_max'] + min_max['x_max']
  tr_label = ''
  x = min_max['x_max']
  y = 0
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < tr
      tr = d
      tr_label = label
    end
  end

  br = min_max['y_max'] + min_max['x_max']
  br_label = ''
  x = min_max['x_max']
  y = min_max['y_max']
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < br
      br = d
      br_label = label
    end
  end

  puts "tl_label #{tl_label}"
  puts "bl_label #{bl_label}"
  puts "tr_label #{tr_label}"
  puts "br_label #{br_label}"
  # pp x_sort
  # pp y_sort

  # Top right corner is a point that has overall max X and overall min
  # Y. Find it by sorting all points by x and all points by y.  Then
  # start at largest X - 1 and smallest Y and look for point that has
  # matching y and label name.
  found = false
  x_sort.reverse.each do |xlabel, xpoint|
    y_sort[0..-2].each do |ylabel, ypoint|
      #puts "Check #{xlabel} #{xpoint} #{ylabel} #{ypoint}"
      if (xlabel == ylabel)
        puts " MATCH TR #{xlabel} #{xpoint}"
        all_inputs[xlabel]['corner'] = 'TR'
        found = true
        break
      end
    end
    break if found
  end

  # Bottom left corner is similar to to top right.
  found = false
  x_sort[1..-1].each do |xlabel, xpoint|
    y_sort.reverse.each do |ylabel, ypoint|
      #puts "Check #{xlabel} #{xpoint} #{ylabel} #{ypoint}"
      if (xlabel == ylabel)
        puts " MATCH BL #{xlabel} #{xpoint}"
        all_inputs[xlabel]['corner'] = 'BL'
        found = true
        break
      end
    end
    break if found
  end

  # Top left corner
  found = false
  x_sort.each do |xlabel, xpoint|
    y_sort.each do |ylabel, ypoint|
      #puts "Check #{xlabel} #{xpoint} #{ylabel} #{ypoint}"
      if (xlabel == ylabel)
        puts " MATCH TL #{xlabel} #{xpoint}"
        all_inputs[xlabel]['corner'] = 'TL'
        found = true
        break
      end
    end
    break if found
  end

  # Bottom corner
  found = false
  x_sort.reverse.each do |xlabel, xpoint|
    y_sort.reverse.each do |ylabel, ypoint|
      #puts "Check #{xlabel} #{xpoint} #{ylabel} #{ypoint}"
      if (xlabel == ylabel)
        puts " MATCH BR #{xlabel} #{xpoint}"
        all_inputs[xlabel]['corner'] = 'BR'
        found = true
        break
      end
    end
    break if found
  end

end


def find_corners(all_inputs, min_max)
  puts "#{__method__}:: "

  x_sort = all_inputs.sort_by {|_key, value| value['x']}
  y_sort = all_inputs.sort_by {|_key, value| value['y']}

  min_max['x_min'] = x_sort[0][1]['x']
  min_max['x_max'] = x_sort[-1][1]['x']
  min_max['y_min'] = y_sort[0][1]['y']
  min_max['y_max'] = y_sort[-1][1]['y']
  pp min_max

  #tr = (x - point['x']).abs + (y - point['y']).abs
  tl = min_max['y_max'] + min_max['x_max']
  tl_label = ''
  x = 0
  y = 0
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < tl
      tl = d
      tl_label = label
    end
  end

  bl = min_max['y_max'] + min_max['x_max']
  bl_label = ''
  x = 0
  y = min_max['y_max']
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < bl
      bl = d
      bl_label = label
    end
  end

  tr = min_max['y_max'] + min_max['x_max']
  tr_label = ''
  x = min_max['x_max']
  y = 0
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < tr
      tr = d
      tr_label = label
    end
  end

  br = min_max['y_max'] + min_max['x_max']
  br_label = ''
  x = min_max['x_max']
  y = min_max['y_max']
  all_inputs.each do |label, point|
    d = (x - point['x']).abs + (y - point['y']).abs
    if d < br
      br = d
      br_label = label
    end
  end

  puts "tl_label #{tl_label}"
  puts "bl_label #{bl_label}"
  puts "tr_label #{tr_label}"
  puts "br_label #{br_label}"

  all_inputs[tl_label]['corner'] = 'TL'
  all_inputs[bl_label]['corner'] = 'BL'
  all_inputs[tr_label]['corner'] = 'TR'
  all_inputs[br_label]['corner'] = 'BR'
end


def read_input(file_name)

  all_inputs = Hash.new

  label = 'A'
  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    x,y = line.split(', ')
    all_inputs[label] = {
      'x' => x.to_i,
      'y' => y.to_i,
      'corner' => nil,
      'area' => 1,
      'scan_area' => 1
    }
    puts "Read/parsed #{label} #{x} #{y}"
    label.next!
  end
  return all_inputs
end

def print_grid(grid, data=false)
  # total = 0

  # print x axis numbers
  print "  "
  grid[0].each_index do |x|
    print "#{x}".ljust(2)
    #break if x > 96
  end
  puts ""
  
  grid.each_index do |y|
    print "#{y} "
    grid[y].each_index do |x|
      if data
        puts grid[y][x]
      else
        print grid[y][x]['disp'].ljust(2)
      end
      #break if x > 96
    end
    puts ""
  end
end

def create_grid(min_max)
  #grid = Array.new(min_max['x_max']+1) { Array.new(min_max['y_max']+1, ".")}
  
  grid = Array.new(min_max['y_max']+1) { Array.new(min_max['x_max']+2, ".") }
  #grid = Array.new(min_max['y_max']+1) { Array.new(min_max['x_max']+1, ".") }
  max_dist = grid.length + grid[0].length
  grid.each_index do |y|
    grid[y].each_index do |x|
      grid[y][x] = {
        'disp' => '.',
        'label' => '.',
        'dist' => max_dist,
        'is_point' => false,
        'y' => y,
        'x' => x
      }
    end
  end
  return grid
end


def buggy_distances_grid(grid, all_inputs)
  grid.each_index do |y|
    grid[y].each_index do |x|
      all_inputs.each do |label, point|
        # compute distance between grid x,y and point
        next if grid[y][x]['is_point']
        d = (x - point['x']).abs + (y - point['y']).abs
        if d < grid[y][x]['dist']
          unless grid[y][x]['disp'] == '.'
            old_label = grid[y][x]['label']
            all_inputs[old_label]['area']-=1
          end
          grid[y][x]['dist'] = d
          grid[y][x]['label'] = label
          grid[y][x]['disp'] = label.downcase
          point['area']+=1
        elsif d == grid[y][x]['dist']
          unless grid[y][x]['disp'] == '.'
            old_label = grid[y][x]['label']
            all_inputs[old_label]['area']-=1
          end
          grid[y][x]['dist'] = d
          grid[y][x]['label'] += label
          grid[y][x]['disp'] = '.'
        end
      end
    end
  end
end

def distances_grid(grid, all_inputs)
  grid.each_index do |y|
    grid[y].each_index do |x|
      dists = Hash.new
      all_inputs.each do |label, point|
        # compute distance between grid x,y and point
        # don't compute distance for points
        next if grid[y][x]['is_point']
        d = (x - point['x']).abs + (y - point['y']).abs
        dists[label] = d
      end
      next if dists.empty?
      # now that we have array of distances for x,y to all points, find min.
      sorted_dists = dists.sort_by {|_key, value| value}
      # Two points have same dist to current grid point
      if sorted_dists[0][1] == sorted_dists[1][1]
        grid[y][x]['disp'] = '.'
      else
        grid[y][x]['dist'] = sorted_dists[0][1]
        grid[y][x]['label'] = sorted_dists[0][0]
        grid[y][x]['disp'] = sorted_dists[0][0].downcase
      end
      # print "DIST #{grid[y][x]}  "
      # pp sorted_dists
    end
  end
end


def find_largest_area(grid, all_inputs)
  all_inputs.each do |label, p|
    next unless p['corner'].nil?
    # scan grid
    grid.each_index do |y|
      grid[y].each_index do |x|
        next if grid[y][x]['disp'] == '.'

        if grid[y][x]['disp'] == label.downcase
          p['scan_area'] += 1
        end
      end
    end
  end
end

def solve(input_file)
  all_inputs = read_input(input_file)

  #puts all_inputs
  min_max = Hash.new
  find_corners(all_inputs, min_max)

  pp all_inputs

  grid = create_grid(min_max)
  #print_grid(grid)

  all_inputs.each do |key, p|
    grid[p['y']][p['x']]['disp'] = key
    grid[p['y']][p['x']]['label'] = key
    grid[p['y']][p['x']]['is_point'] = true
  end
  puts "*"*20
  #print_grid(grid)
  distances_grid(grid, all_inputs)

  print_grid(grid, true)

  pp all_inputs

  area_sort = all_inputs.sort_by {|_key, value| value['area']}.reverse
  area_sort.each do |label, point|
    next unless point['corner'].nil?
    print "#{label} "
    pp point
    break
  end
  puts "*"*20
  find_largest_area(grid, all_inputs)
  area_sort = all_inputs.sort_by {|_key, value| value['scan_area']}.reverse
  area_sort.each do |label, point|
    next unless point['corner'].nil?
    print "#{label} "
    pp point
  end
end

solve('sample.txt')

# solve('sample2.txt')
# solve('sample3.txt')

solve('aoc_06_2018_input.txt')
#solve('alt_input.txt')
