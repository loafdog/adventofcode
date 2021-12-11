#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2021/day/4

# --- Day 4: Giant Squid ---
# You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

# Maybe it wants to play bingo?

# Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

# The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19

#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6

# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
# After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
# After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
# Finally, 24 is drawn:

# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
# At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).

# The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

# To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?

class Game
  attr :boards
  attr :draws
  attr :draw_index
  attr :winning_boards
  attr_accessor :first_board_wins

  def initialize(draws, boards)
    @boards = boards
    @draws = draws.split(',')
    @draw_index = 0
    @winning_boards = []
    @first_board_wins = true
  end

  def print
    puts "draw index #{@draw_index} draw #{draws[draw_index]}"
    puts draws.join(' ')
    puts ""
    @boards.each do |b|
      b.print
      puts ""
    end
    puts "="*80
  end

  def play
    draws.each_with_index do |d, di|
      @draw_index = di
      @boards.each_with_index do |b, bnum|
        if @draw_index > 4
          if b.has_won
            puts "board #{b.board_id} has already won."
            next
          end
          if b.win?
            puts ""
            sum = b.sum_unmarked
            @winning_boards << b
            puts "Found win on board #{b.board_id}  d=#{d} di=#{@draw_index} @winning_boards.length=#{@winning_boards.length} sum=#{sum} final score=#{sum * d.to_i}"
            puts ""
            if game_over?
              puts "game is over: @first_board_wins=#{@first_board_wins} @winning_boards.length=#{@winning_boards.length} @boards.length=#{@boards.length}"
              # break
              return
            end
          else
            i,j = b.mark(d)
            if i.nil?
              puts "d=#{d} di=#{di} not found on board #{bnum+1}"
            else
              puts "d=#{d} di=#{di} found on board #{bnum+1} #{i} #{j}"
            end
          end
        else
          # first 4 digits drawn don't need to check for win.
          i,j = b.mark(d)
          if i.nil?
            puts "d=#{d} di=#{di} not found on board #{bnum+1}"
          else
            puts "d=#{d} di=#{di} found on board #{bnum+1} #{i} #{j}"
          end
        end
      end
      print
    end

    # if @first_board_wins
    #   b = @winning_boards[0]
    # else
    #   b = @winning_boards[-1]
    # end
    # b.print_win
    puts "DONE playing game"
  end

  def print_win
    if @first_board_wins
      b = @winning_boards[0]
    else
      b = @winning_boards[-1]
    end
    b.print_win
  end

  def game_over?
    puts "game_over? @first_board_wins=#{@first_board_wins} @winning_boards.length=#{@winning_boards.length} @boards.length=#{@boards.length}"
    if @first_board_wins && @winning_boards.length == 1
      true
    elsif @first_board_wins == false && @winning_boards.length == @boards.length
      #binding.pry
      true
    else
      false
    end
  end

end

class Board
  attr :lines
  attr :board_id
  attr :board
  attr :state
  attr :won
  attr :last_mark

  attr_accessor :has_won

  def initialize(board_lines, board_id)
    @board_id = board_id
    @lines = board_lines
    @board = Array.new(board_lines.length)
    board_lines.each_with_index do |l, i|
      @board[i] = []
      l.split(' ').each do |n|
        @board[i] << n
      end
    end
    @state = Array.new(board_lines.length)
    @state.each_with_index do |s, i|
      @state[i] = Array.new(board_lines.length, '.')
    end
    @won = false
    @has_won = false
  end

  def print
    puts "Board #{@board_id}"
    @lines.each_with_index do |line, i|
      bstr = @board[i].map{|v| "#{("%2s"%v)}"}.join(" ")
      #puts line + "   " + bstr + "  " + @state[i].join(" ")
      puts bstr + "  " + @state[i].join(" ")
    end
  end

  def print_win
    if @won
      sum = sum_unmarked
      puts "wooha board #{@board_id}  last_draw=#{@last_mark}  sum=#{sum} final score=#{sum * last_mark.to_i}"
    else
      raise "uh oh board #{@board_id}  last_draw=#{@last_mark}  is not marked won?"
    end
  end

  def mark(num)
    @board.each_with_index do |row, i|
      row.each_with_index do |val, j|
        if val == num
          state[i][j] = '*'
          @last_mark = num
          return i,j
        end
      end
    end
    return nil,nil
  end

  def sum_unmarked
    sum = 0
    @board.each_with_index do |row, i|
      row.each_with_index do |val, j|
        if state[i][j] != '*'
          sum += val.to_i
        end
      end
    end
    sum
  end


  def win?
    if @won
      return true
    end
    if @has_won
      return true
    end
    # check if a row is winner
    @state.each_with_index do |row, i|
      #binding.pry
      if row.all?{|v| v == '*'}
        puts "row #{i} is winner on board #{@board_id}"
        @won = @has_won = true
        return true
      end
    end
    # check if a row is winner
    (0..@state.length-1).each do |j|
      all_star = true
      (0..@state.length-1).each do |i|
        #puts "i=#{i} j=#{j}"
        if @state[i][j] == '.'
          all_star = false
          break
        end
      end
      if all_star
        puts "col #{j} is winner on board #{@board_id}"
        @won = @has_won = true
        return true
      end
    end
    return false
  end

end

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read
  draws = []
  board_lines = []
  boards = []
  input_data.each_line do |line|
    if line.include?(',')
      draws = line.chomp
    elsif line.chomp.empty? && board_lines.length > 0
      b = Board.new(board_lines, boards.length + 1)
      boards << b
      board_lines = []
    elsif line.chomp.empty?
      puts "skip empty"
    else
      board_lines << line.chomp
    end
  end

  puts "input_data: draws=#{draws.split(',').length} boards=#{boards.length}"
  g = Game.new(draws, boards)
  g
end

def write_output(file_name, output)
  #File.write(file_name, output.join("\n"), mode: 'w')
end

def part1(input_file)
  game = read_input(input_file)
  game.first_board_wins = true
  game.print
  game.play
  game.print_win
  #game.print
end

def part2(input_file)
  game = read_input(input_file)
  game.first_board_wins = false
  game.print
  game.play
  game.print_win
  #game.print
end

puts ""
puts "part 1 sample"
part1('aoc_04_2021_input_sample.txt')

puts ""
puts "part 1"
part1('aoc_04_2021_input.txt')

puts ""
puts "part 2 sample"
part2('aoc_04_2021_input_sample.txt')

puts ""
puts "part 2"
part2('aoc_04_2021_input.txt')
