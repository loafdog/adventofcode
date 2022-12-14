#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/2

# --- Day 2: Rock Paper Scissors ---
# The Elves begin to set up camp on the beach. To decide whose tent gets to be closest to the snack storage, a giant Rock Paper Scissors tournament is already in progress.

# Rock Paper Scissors is a game between two players. Each game contains many rounds; in each round, the players each simultaneously choose one of Rock, Paper, or Scissors using a hand shape. Then, a winner for that round is selected: Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock. If both players choose the same shape, the round instead ends in a draw.

# Appreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

# The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

# The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

# Since you can't be sure if the Elf is trying to help you or trick you, you should calculate the score you would get if you were to follow the strategy guide.

# For example, suppose you were given the following strategy guide:

# A Y
# B X
# C Z
# This strategy guide predicts and recommends the following:

# In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
# In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
# The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.
# In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

# What would your total score be if everything goes exactly according to your strategy guide?



# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors

# 1 for Rock, 2 for Paper, and 3 for Scissors
# 0 if you lost, 3 if the round was a draw, and 6 if you won

# --- Part Two ---
# The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

# The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

# In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
# In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
# In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.
# Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

# Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?

 

def part2(file_name)
  file = File.open(file_name)
  input_data = file.read

  total_you = 0
  total_me = 0

  win = 6
  draw = 3
  lose = 0

  rock = 1
  paper = 2
  scissor = 3

  input_data.each_line do |line|
    #puts "line=[#{line}]"
    line.chomp!
    (you, me) = line.split(' ')

  
    # add up points for playing choice
    throw_you = -1
    case you
    when 'A'
      throw_you = rock
    when 'B'
      throw_you = paper
    when 'C'
      throw_you = scissor
    else
      raise "you is invalid [#{you}] line=[#{line}]"
    end


    # X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win.
    
    throw_me = -1
    
    case me
    when 'X' # me lose
      if throw_you == rock
        throw_me = scissor
      elsif throw_you == paper
        throw_me = rock
      elsif throw_you == scissor
        throw_me = paper
      else
        raise "throw_you is invalid [#{throw_you}] line=[#{line}]"
      end
    when 'Y' # draw
      throw_me = throw_you
    when 'Z' # me win
      if throw_you == rock
        throw_me = paper
      elsif throw_you == paper
        throw_me = scissor
      elsif throw_you == scissor
        throw_me = rock
      else
        raise "throw_you is invalid [#{throw_you}] line=[#{line}]"
      end
    else
      raise "me is invalid [#{me}] line=[#{line}]"
    end

    points_me = 0
    points_you = 0
    # determine win/lose/draw
    if throw_you == throw_me
      points_you = draw
      points_me = draw
    else
      case throw_me
      when rock
        if throw_you == scissor
          points_me = win
        elsif throw_you == paper
          points_you = win
        else
          raise "shouldnt be here: throw_me=[#{throw_me}] throw_you=[#{throw_you}] line=[#{line}]"
        end
      when paper
        if throw_you == scissor
          points_you = win
        elsif throw_you == rock
          points_me = win
        else
          raise "shouldnt be here: throw_me=[#{throw_me}] throw_you=[#{throw_you}] line=[#{line}]"
        end
      when scissor
        if throw_you == rock
          points_you = win
        elsif throw_you == paper
          points_me = win
        else
          raise "shouldnt be here: throw_me=[#{throw_me}] throw_you=[#{throw_you}] line=[#{line}]"
        end
      else
        raise "shouldnt be here: throw_me=[#{throw_me}] throw_you=[#{throw_you}] line=[#{line}]"
      end
    end
    round_you = points_you + throw_you
    round_me = points_me + throw_me
    
    total_you += round_you
    total_me += round_me
    
    puts "#{line}  #{throw_you} #{throw_me}  #{points_you} #{points_me}  #{round_you} #{round_me}" 
  end
  puts "total_you=#{total_you}"
  puts "total_me=#{total_me}"
end


puts ""
puts "sample"
part2('aoc_02_2022_sample_input.txt')
puts ""
puts "actual"
part2('aoc_02_2022_input.txt')

# First guess was wrong, too high
#
# actual
# total_you=16543
# total_me=11876

# third guess too low
#
# actual
# total_you=13334
# total_me=7032

# fourth guess was right
#
# total_you=13334
# total_me=11873
