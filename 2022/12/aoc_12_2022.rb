#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/12

# --- Day 12: Hill Climbing Algorithm ---
# You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.

# You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to the highest elevation, z.

# Also included on the heightmap are marks for your current position (S) and the location that should get the best signal (E). Your current position (S) has elevation a, and the location that should get the best signal (E) has elevation z.

# You'd like to reach E, but to save energy, you should do it in as few steps as possible. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be at most one higher than the elevation of your current square; that is, if your current elevation is m, you could step to elevation n, but not to elevation o. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)

# For example:

# Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi
#
# Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the e at the bottom. From there, you can spiral around to the goal:

# v..v<<<<
# >v.vv<<^
# .>vv>E^^
# ..v>>>^^
# ..>>>>>^
# In the above diagram, the symbols indicate whether the path exits each square moving up (^), down (v), left (<), or right (>). The location that should get the best signal is still E, and . marks unvisited squares.

# This path reaches the goal in 31 steps, the fewest possible.

# What is the fewest steps required to move from your current position to the location that should get the best signal?

# --- Part Two ---
# As you walk up the hill, you suspect that the Elves will want to turn this into a hiking trail. The beginning isn't very scenic, though; perhaps you can find a better starting point.

# To maximize exercise while hiking, the trail should start as low as possible: elevation a. The goal is still the square marked E. However, the trail should still be direct, taking the fewest steps to reach its goal. So, you'll need to find the shortest path from any square at elevation a to the square marked E.

# Again consider the example from above:

# Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi
# Now, there are six choices for starting position (five marked a, plus the square marked S that counts as being at elevation a). If you start at the bottom-left square, you can reach the goal most quickly:

# ...v<<<<
# ...vv<<^
# ...v>E^^
# .>v>>>^^
# >^>>>>>^
# This path reaches the goal in only 29 steps, the fewest possible.

# What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?


##############################################################################
# MY NOTES
#
# Seems like this is good case for shortest path, dijkstra's algo?
#
# I ended up using BFS.  I started looking online for description of
# shortest path algos.  I ran into a few problems/bugs in my code.
# The sample passed.  But part 1 did not.
#
# First problem was I misread problem and thought you could only go to
# next spot if letter was equal or one greater.  But you can go lower
# as much as you want.  The sample does not have any path that goes
# lower, letters always stay same or increase.
#
# Second mistake was in the bfs algo.  It was taking long time to
# complete.  I did some debug and noticed the queue of nodes to check
# was growing very large.  I added a check to see if node was visited
# right after shifting node from front.  I was only checking if
# visited when looping thru adjacent nodes.
#
# Alot of the code in this day's problem was written to check if I
# made mistake reading/parsing input.  And printing out the graph/map
# to see what state was.
#
# Part 2.. I got ideas from reading about part 1 solutions when trying
# to figure out why my code did not work.  Two ideas.  One is get a
# list of every 'a' and try bfs search for each.  Select shorted
# possible path.  Second idea is to start search from 'z' and go to
# 'a'.  I ran into a few problems/bugs with this idea.
#
# When parsing input into a node graph, I reversed the comparisons so
# that z -> y -> x -> etc would work.  I saw someone else do ruby code
# that did this but with a really slick looking polarity var/logic
# thing.
# https://github.com/tobyaw/advent-of-code-2022/blob/master/day_12.rb
# I did not do this.
#
# Changing rest of code to switch start/finish a/z char took a bit of
# work.
#
# Final problem I had was when to exit search loop.  Part 1 gave you
# coords to end search.  Part 2 you don't know the coord, just that
# you are looking for 'a'.  Took me a night sleep to realize this and
# how to change the code.

require 'pry'
require 'set'

class Graph

  attr_reader :start,:finish

  def initialize(lines: [], start_char: 'S', finish_char: 'E')

    @lines = lines
    @nodes = {}
    @start = @finish = nil


    # find start first, and change it to a and z respectively. Makes
    # writing comparisons to check for adjacent nodes easier.
    lines.each_with_index do |line, r|
      line.each_with_index do |ch, c|
        n = "#{r},#{c}"
        if ch.chr == start_char
          @start = n
          if start_char == 'S'
            ch = 'a'.bytes[0]
          else
            ch = 'z'.bytes[0]
          end
          lines[r][c] = ch
        elsif ch.chr == finish_char
          @finish = n
          if finish_char == 'E'
            ch = 'z'.bytes[0]
          else
            ch = 'a'.bytes[0]
          end
          lines[r][c] = ch
        end
      end
    end

    lines.each_with_index do |line, r|
      line.each_with_index do |ch, c|
        n = "#{r},#{c}"

        edges = {}

        if start_char == 'S'
          # check if up can be reached
          if r - 1 >= 0 && (lines[r-1][c] <= ch + 1)
            # add node to graph
            # edges << "#{r-1},#{c}"
            edges["#{r-1},#{c}"] = 1
          end
          # check if down can be reached
          if r + 1 < lines.length && (lines[r+1][c] <= ch + 1)
            # add node to graph
            # edges << "#{r+1},#{c}"
            edges["#{r+1},#{c}"] = 1
          end
          # check if left can be reached
          if c - 1 >= 0 && (lines[r][c-1] <= ch + 1)
            # add node to graph
            edges["#{r},#{c-1}"] = 1
          end
          # check if right can be reached
          if c + 1 < line.length && (lines[r][c+1] <= ch + 1)
            # add node to graph
            edges["#{r},#{c+1}"] = 1
          end
        elsif start_char == 'E'
          # check if up can be reached
          if r - 1 >= 0 && (lines[r-1][c] >= ch - 1)
            # add node to graph
            # edges << "#{r-1},#{c}"
            edges["#{r-1},#{c}"] = 1
          end
          # check if down can be reached
          if r + 1 < lines.length && (lines[r+1][c] >= ch - 1)
            # add node to graph
            # edges << "#{r+1},#{c}"
            edges["#{r+1},#{c}"] = 1
          end
          # check if left can be reached
          if c - 1 >= 0 && (lines[r][c-1] >= ch - 1)
            # add node to graph
            edges["#{r},#{c-1}"] = 1
          end
          # check if right can be reached
          if c + 1 < line.length && (lines[r][c+1] >= ch - 1)
            # add node to graph
            edges["#{r},#{c+1}"] = 1
          end

        else
          raise "invalid start_char=#{start_char}"
        end

        # FIRST MISTAKE, was only checking if adjacent node was equal
        # or one greater.  Less than was ok too
        #
        # check if up can be reached
        # if r - 1 >= 0 && (lines[r-1][c] == ch || lines[r-1][c] == ch + 1)
        #   # add node to graph
        #   # edges << "#{r-1},#{c}"
        #   edges["#{r-1},#{c}"] = 1
        # end
        # # check if down can be reached
        # if r + 1 < lines.length && (lines[r+1][c] == ch || lines[r+1][c] == ch + 1)
        #   # add node to graph
        #   # edges << "#{r+1},#{c}"
        #   edges["#{r+1},#{c}"] = 1
        # end
        # # check if left can be reached
        # if c - 1 >= 0 && (lines[r][c-1] == ch || lines[r][c-1] == ch + 1)
        #   # add node to graph
        #   edges["#{r},#{c-1}"] = 1
        # end
        # # check if right can be reached
        # if c + 1 < line.length && (lines[r][c+1] == ch || lines[r][c+1] == ch + 1)
        #   # add node to graph
        #   edges["#{r},#{c+1}"] = 1
        # end

        @nodes[n] = {
          char: ch.chr,
          prev: nil,
          depth: 0,
          visit: false,
          edges: edges,
        }
      end

    end

    puts "Done building graph: "
    puts "  start=#{@start} finish=#{@finish}"
    puts "  @nodes = #{@nodes.length}"
    puts "  input size #{@lines.length}x#{@lines[0].length}"
    no_adj = 0
    @nodes.each do |n,v|
      if v[:edges].empty?
        no_adj += 1
      end
    end
    puts "  nodes w/o adjacent nodes: #{no_adj}"
    #pp @nodes
    puts ""
  end

  def graph_to_input
    test_graph = []
    @lines.each do |l|
      a = '.'* l.length
      test_graph << a.chars
    end
    @nodes.each do |n,v|
      r,c = n.split(',').map {|i| i.to_i}
      test_graph[r][c] = v[:char]
    end

    test_graph.each_with_index do |_row, i|
      # each array row is a array of chars or bytes. convert to string
      # to compare.
      t = test_graph[i].join
      l = @lines[i].map{|c| c.chr}.join
      if t != l
        #if test_graph[i].to_s != @lines[i].to_s
        puts "line #{i} no match"
        puts " l #{l}"
        puts " t #{t}"
        # puts " l  #{@lines[i].to_s}"
        # puts " t  #{test_graph[i].to_s}"
      end
    end
  end

  def print_chars_graph
    print "  "
    0.upto(@lines.first.length-1) do |i|
      print i % 10
    end
    puts ""
    @lines.each_with_index do |row, r|
      print "#{r%10} "
      row.each do |b|
        print b.chr
      end
      print " #{r%10}"
      puts ""
    end
    print "  "
    0.upto(@lines.first.length-1) do |i|
      print i % 10
    end
    puts ""
  end

  def print_path_graph(start: @start, finish: @finish)
    # first make empty arrays with '.'
    path = []
    @lines.each do |l|
      a = '.'* l.length
      path << a.chars
    end

    cur = finish
    while cur != start && !cur.nil?
      puts "cur=#{cur} #{@nodes[cur]}"
      n = @nodes[cur]
      if n[:prev]
        pr,pc = n[:prev].split(',').map {|i| i.to_i}
        r,c = cur.split(',').map {|i| i.to_i}

        dir = '.'
        if pc - c < 0
          dir = '>'
        elsif pc - c > 0
          dir = '<'
        elsif pr - r < 0
          dir = 'v'
        elsif pr - r > 0
          dir = '^'
        else
          dir = '#'
        end
        path[pr][pc] = dir.chars[0]
        #binding.pry
        cur = n[:prev]
      end
    end

    print "  "
    0.upto(path.first.length-1) do |i|
      print i%10
    end
    puts ""
    path.each_with_index do |row, r|
      print "#{r%10} "
      row.each do |b|
        print b.chr
      end
      print " #{r%10}"
      puts ""
    end
    print "  "
    0.upto(path.first.length-1) do |i|
      print i%10
    end
    puts ""
  end

  def print_visited_graph
    # first make empty arrays with '.'
    path = []
    @lines.each do |l|
      a = '.'* l.length
      path << a.chars
    end

    @nodes.each do |n,v|
      r,c = n.split(',').map {|i| i.to_i}
      if v[:visit]
        path[r][c] = '#'.chars[0]
      else
        path[r][c] = @lines[r][c]
      end
    end

    print "  "
    0.upto(path.first.length-1) do |i|
      print i%10
    end
    puts ""
    path.each_with_index do |row, r|
      print "#{r%10} "
      row.each do |b|
        print b.chr
      end
      print " #{r%10}"
      puts ""
    end
    print "  "
    0.upto(path.first.length-1) do |i|
      print i%10
    end
    puts ""
  end

  #############################################################################
  #
  def find_shortest_path_bfs(start: @start, finish: @finish)
    path = []
    visited = Set.new
    queue = [start]

    if @nodes[finish][:char] == 'z'
      puts "looking for finish = #{finish} #{@nodes[finish][:char]}"
    else
      puts "looking for finish = ? 'a'"
    end

    while !queue.empty?
      n = queue.shift

      # SECOND PROBLEM/bug.  First try did not check visited here,
      # checked later in adj node loop.
      #
      next if visited.include?(n)

      visited.add(n)
      @nodes[n][:visit] = true

      if @nodes[finish][:char] == 'z'
        if n == finish
          puts "found finish: #{finish}"
          break
        end
      else
        if @nodes[n][:char] == 'a'
          puts "found finish: #{n}"
          @finish = finish = n
          break
        end
      end

      adjs = @nodes[n][:edges]
      adjs.each do |adjacent|
        # SECOND PROBLEM/bug.  First try checked if visited only
        # here.  This caused queue to grow and never get empty.  If I
        # remove this check path is not found.  Need this here too.
        #
        next if visited.include?(adjacent[0])

        @nodes[adjacent[0]][:depth] = @nodes[n][:depth] + 1
        @nodes[adjacent[0]][:prev] = n
        queue.push(adjacent[0])
      end
      #binding.pry

      # Some debug code when trying to figure out why queue got so big
      #
      # if queue.length > 500
      #   pp @nodes
      #   puts "num nodes visited: #{visited.length}"
      #   puts "start  #{start} #{@nodes[start]}"
      #   puts "finish #{finish} #{@nodes[finish]}"
      #   print_chars_graph
      #   print_visited_graph
      #   return
      # end

    end

    # Uncomment these lines to get output of all nodes and pictures of
    # graphs.  Best to output to file if running with this code
    # enabled.
    #
    # pp @nodes
    # print_chars_graph
    # print_visited_graph
    # print_path_graph(start: start, finish: finish)

    puts "num nodes visited: #{visited.length}"
    puts "start  #{start} #{@nodes[start]}"
    puts "finish #{finish} #{@nodes[finish]}"

  end

  def find_shortest_path_dijkstra
    unvisited_nodes = @nodes.keys
    shortest_path = {}
    prev_nodes = {}

    @nodes.keys.each do |n|
      shortest_path[n] = 4611686018427387903
    end
    shortest_path[@start] = 0
    #pp shortest_path

    # visit each node
    unvisited_nodes.reverse_each do |v|
      puts "visit #{v}"

      min_node = unvisited_nodes.first
      unvisited_nodes.each do |n|
        if shortest_path[n] < shortest_path[min_node]
          min_node = n
        end
      end

      puts "visit #{v} min_node=#{min_node} path_val=#{shortest_path[min_node]}"

      # at each node check neighbors and update distance
      neighbors = @nodes[v]
      puts "visit #{v} neighbors=#{neighbors}"
      neighbors.each do |n|
        temp = shortest_path[min_node] + 1
        if temp < shortest_path[n]
          shortest_path[n] = temp
          puts "visit #{v} neighbor=#{n} path_val=#{temp}"
          prev_nodes[n] = min_node
        end
      end
      puts "remove #{v}"
      unvisited_nodes.delete(v)
    end

    return prev_nodes, shortest_path
  end

end

def read_input(file_name: nil)
  file = File.open(file_name)
  input_data = file.read
  input_lines = input_data.split("\n")

  # input_lines.each do |line|
  #   line.chars.each do |c|
  #     print c
  #   end
  #   puts ""
  # end

  # input_lines.each do |line|
  #   line.bytes.each_with_index.each do |ch, c|
  #     print ' '
  #     print ch
  #   end
  #   puts ""
  # end

  lines = []
  input_lines.each do |line|
    lines << line.bytes
  end
  lines
end

puts "-"*80
puts "part 1 sample"
lines = read_input(file_name: 'aoc_12_2022_sample_input.txt')
graph = Graph.new(lines: lines)
graph.graph_to_input
graph.find_shortest_path_bfs
puts "-"*80
puts "part 2 sample"
lines = read_input(file_name: 'aoc_12_2022_sample_input.txt')
graph = Graph.new(lines: lines, start_char: 'E', finish_char: 'S')
graph.graph_to_input
graph.find_shortest_path_bfs

puts "-"*80
puts "part 1 "
lines = read_input(file_name: 'aoc_12_2022_input.txt')
graph = Graph.new(lines: lines)
graph.graph_to_input
graph.find_shortest_path_bfs
puts "-"*80
puts "part 2 "
lines = read_input(file_name: 'aoc_12_2022_input.txt')
graph = Graph.new(lines: lines, start_char: 'E', finish_char: 'S')
graph.graph_to_input
graph.find_shortest_path_bfs

