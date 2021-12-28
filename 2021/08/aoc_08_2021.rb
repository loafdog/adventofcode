#!/usr/bin/env ruby
require 'pry'
require 'set'

# https://adventofcode.com/2021/day/8

# --- Day 8: Seven Segment Search ---

# You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

# As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

# Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

# So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

# The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

# So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.

# For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

# For example, here is what you might see in a single entry in your notes:

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
# cdfeb fcadb cdfeb cdbaf

# (The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

# Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

# Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.

# For now, focus on the easy digits. Consider this larger example:

# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
# fdgacbe cefdb cefbgd gcbe
# edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
# fcgedb cgb dgebacf gc
# fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
# cg cg fdcagb cbg
# fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
# efabcd cedba gadfec cb
# aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
# gecf egdcabf bgf bfgea
# fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
# gebdcfa ecba ca fadegcb
# dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
# cefg dcbef fcge gbcadfe
# bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
# ed bcgafe cdgba cbgef
# egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
# gbdfcae bgc cg cgb
# gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
# fgae cfgab fg bagce

# Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

# In the output values, how many times do digits 1, 4, 7, or 8 appear?

# Your puzzle answer was 504.

# --- Part Two ---

# Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
# cdfeb fcadb cdfeb cdbaf

# After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

#  dddd
# e    a
# e    a
#  ffff
# g    b
# g    b
#  cccc

# So, the unique signal patterns would correspond to the following digits:

#     acedgfb: 8
#     cdfbe: 5
#     gcdfa: 2
#     fbcad: 3
#     dab: 7
#     cefabd: 9
#     cdfgeb: 6
#     eafb: 4
#     cagedb: 0
#     ab: 1

# Then, the four digits of the output value can be decoded:

#     cdfeb: 5
#     fcadb: 3
#     cdfeb: 5
#     cdbaf: 3

# Therefore, the output value for this entry is 5353.

# Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

#     fdgacbe cefdb cefbgd gcbe: 8394
#     fcgedb cgb dgebacf gc: 9781
#     cg cg fdcagb cbg: 1197
#     efabcd cedba gadfec cb: 9361
#     gecf egdcabf bgf bfgea: 4873
#     gebdcfa ecba ca fadegcb: 8418
#     cefg dcbef fcge gbcadfe: 4548
#     ed bcgafe cdgba cbgef: 1625
#     gbdfcae bgc cg cgb: 8717
#     fgae cfgab fg bagce: 4315

# Adding all of the output values in this larger example produces 61229.

# For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?

# Your puzzle answer was 1073431.



# NOTE to self
#
# I did a bad job choosing data structure and organizing code for part
# 2.  Did not realize Set would make solving this puzzle easier until
# I already had a sort of working solution using arrays.  I kept
# hacking away at it adding Set and then methods to Digit class.  This
# is very confusing code to follow.  Not gonna bother cleaning it
# up...

class Digit
  attr_accessor :pattern
  attr :digit
  attr_accessor :segments
  attr_accessor :sets

  def initialize(pattern)
    @pattern = pattern
    @digit = to_possible_digit
    @segments = Array.new(7, nil)
  end

  def mark_segment(index, letter)
    @segments[index] = letter
  end

  def to_s
    #@pattern + " " + @digit.to_s
    @pattern.chars.sort.join + " " + @digit.to_s + " " + @segments.to_s
  end

  def value
    @digit[0].to_s
  end

  def set_pattern_map()
    zero = @segments[0..2] + @segments[4..6]
    six = @segments[0..1] + @segments[3..6]
    nine = @segments[0..3] + @segments[5..6]

    two = (@segments[0] + @segments[2..4].join + @segments[6]).chars
    three = (@segments[0] + @segments[2..3].join + @segments[5..6].join).chars
    five = (@segments[0..1].join + @segments[3] + @segments[5..6].join).chars

    # puts "zero #{zero}"
    # puts "six #{six}"
    # puts "nine #{nine}"
    # puts "two #{two}"
    # puts "three #{three}"
    # puts "five #{five}"

    @sets = {}
    @sets['0'] = zero.to_set
    @sets['6'] = six.to_set
    @sets['9'] = nine.to_set
    @sets['2'] = two.to_set
    @sets['3'] = three.to_set
    @sets['5'] = five.to_set
  end

  def pattern_to_digit(sets)
    pset = Set.new(@pattern.chars)
    sets.each do |k,v|
      if v == pset
        @digit = [k.to_i]
        return
      end
    end
  end

  def to_possible_digit
    case @pattern.length
    when 6
      [0,6,9]
    when 5
      [2,3,5]
    when 2
      [1]
    when 4
      [4]
    when 3
      [7]
    when 7
      [8]
    else
      []
      #raise "Invalid pattern/length? [#{@pattern}]"
    end
  end

  def to_digit
    a = to_possible_digit
    if a.length == 1
      return a[0]
    end
    return -1
  end

  def minus(digit)
    if digit.class == Digit
      s1 = Set.new(@pattern.chars)
      s2 = Set.new(digit.pattern.chars)
    else
      s1 = Set.new(@pattern.chars)
      s2 = Set.new(digit)
    end
    if s1.length >= s2.length
      diff = s1 - s2
    else
      diff = s2 - s1
    end
    diff.to_a
  end

  def diff(digits, value)
    all = []
    digits.each do |d|
      all.concat(d.pattern.chars)
    end
    totals = all.tally
    puts "diff totals: " + totals.to_s
    res = totals.select {|k,v| v == value}
    #binding.pry
    res.keys
  end

  def inter(lhs, rhs)
    if lhs.class == Digit
      s1 = Set.new(lhs.pattern.chars)
    else
      s1 = Set.new(lhs)
    end
    if rhs.class == Digit
      s2 = Set.new(rhs.pattern.chars)
    else
      s2 = Set.new(rhs)
    end
    res = s1&s2
    res.to_a
  end

  def minus_arr(arr1, arr2)
    s1 = Set.new(arr1)
    s2 = Set.new(arr2)
    if s1.length >= s2.length
      diff = s1 - s2
    else
      diff = s2 - s1
    end
    diff.to_a
  end

  def plus(digit)
    t = @pattern + digit.pattern
    t.chars.uniq
  end

  def equals?(val)
    if val.class == Array

      if unique? == true
        return false
      end
      #binding.pry
      s1 = Set.new(to_possible_digit)
      s2 = Set.new(val)
      s1.any?(s2)
    else
      unique? && to_digit == val
    end
  end

  def unique?
    @digit.length == 1
  end

end

class Entry
  attr :line
  attr :signals
  attr :outputs
  attr :solution

  def initialize(line)
    @line = line
    @signals = []
    @outputs = []
    parts = line.chomp.split('|')
    sigs = parts[0].split(' ')
    sigs.each do |pattern|
      s = Digit.new(pattern)
      @signals << s
    end
    outs = parts[1].split(' ')
    outs.each do |pattern|
      o = Digit.new(pattern)
      @outputs << o
    end
  end

  def print
    str = ""
    @signals.each do |s|
      str = str + s.to_s + ' '
    end
    str = str + ' | '
    @outputs.each do |o|
      str = str + o.to_s + ' '
    end
    puts str
  end

  def count_output_unique
    count = 0
    @outputs .each do |o|
      if o.unique?
        count += 1
      end
    end
    count
  end

  def solve_for_seg0(seven, one)
    # arr = seven.minus(one)
    # @solution.mark_segment(0, arr[0])
    #puts "1-7 " + arr[0]

    arr = @solution.diff([seven, one], 1)
    @solution.mark_segment(0, arr[0])
    puts "1-7 " + arr[0]
    puts @solution
  end



  #   0:      6:     9:
  #  aaaa    aaaa   aaaa
  # b    c  b    . b    c
  # b    c  b    . b    c
  #  ....    dddd   dddd
  # e    f  e    f .    f
  # e    f  e    f .    f
  #  gggg    gggg   gggg
  # a=3
  # g=3
  # b=3
  # f=3
  # c=2
  # d=2
  # e=2
  #
  # look at cde.  look at 1 cf
  # which one is in both is top right: c
  # other value in one is both right: f
  #
  #   1:     4
  #  ....   ....
  # .    c b    c
  # .    c b    c
  #  ....   dddd
  # .    f .    f
  # .    f .    f
  #  ....   ....

  def solve_for_seg235(one, four, zero_six_nine)
    puts "069 0 #{zero_six_nine[0]}"
    puts "069 1 #{zero_six_nine[1]}"
    puts "069 2 #{zero_six_nine[2]}"
    a = @solution.diff(zero_six_nine, 2)
    puts "069 a #{a}"
    puts "one #{one.pattern}"
    top_right = @solution.inter(one, a)
    puts "top_right=#{top_right}"
    #bot_right = @solution.minus(one, top_right)
    bot_right = one.minus(top_right)
    puts "bot_right=#{bot_right}"
    @solution.mark_segment(2, top_right[0])
    @solution.mark_segment(5, bot_right[0])

    segs = four.minus(one)
    mid = @solution.inter(segs, a)
    puts "mid=#{mid}"
    @solution.mark_segment(3, mid[0])
    mid
  end

  def oldsolve_for_seg235(one, zero_six_nine)
    arr1 = zero_six_nine[0].minus(zero_six_nine[1])
    arr2 = zero_six_nine[1].minus(zero_six_nine[2])
    arr3 = zero_six_nine[0].minus(zero_six_nine[2])

    puts "069 0 #{zero_six_nine[0]}"
    puts "069 1 #{zero_six_nine[1]}"
    puts "069 2 #{zero_six_nine[2]}"
    puts "069 0 minus 1 #{arr1}"
    puts "069 1 minus 2 #{arr2}"
    puts "069 0 minus 2 #{arr3}"

    if arr1[0] == arr2[0]
      mid = arr1
      top_right = arr3
    elsif arr1[0] == arr3[0]
      mid = arr1
      top_right = arr2
    elsif arr2[0] == arr3[0]
      mid = arr2
      top_right = arr1
    end
    puts "mid=#{mid} top_right=#{top_right}"
    @solution.mark_segment(3, mid[0])
    @solution.mark_segment(2, top_right[0])
    puts @solution

    bot_right = one.minus(top_right)
    puts "bot_right=#{bot_right}"
    if bot_right.length > 1
      raise "bot_right=#{bot_right} has more than one possible answer"
    end
    @solution.mark_segment(5, bot_right[0])
    mid
  end

  def solve_for_seg1(one, four, mid)
    arr = four.minus(one)
    #puts "4-1 " + arr.to_s
    top_left = @solution.minus_arr(arr, mid)
    #puts "top_left #{top_left}"
    @solution.mark_segment(1, top_left[0])
    #puts @solution
  end

  #    8:     sol:
  #   aaaa    aaaa
  #  b    c  b    c
  #  b    c  b    c
  #   dddd    dddd
  #  e    f  ?    f
  #  e    f  ?    f
  #   gggg    ????
  #
  # subtract 8 = sol = eg

  #     2:     3       5:
  #   aaaa    aaaa    aaaa
  #  .    c  .    c  b    .
  #  .    c  .    c  b    .
  #   dddd    dddd    dddd
  #  e    .  .    f  .    f
  #  e    .  .    f  .    f
  #   gggg    gggg    gggg
  # c=2
  # f=2
  # b=1
  # e=1
  #
  # then take eg&be = e to get bot left
  #
  def solve_for_seg46(eight, two_three_five)

    # eight - solution so far will give last 2 segments to find
    #
    # puts "eight #{eight.to_s}"
    # puts "sol #{@solution.to_s}"
    # segs = eight.minus(@solution)
    #segs = @solution.minus(eight)
    #segs = @solution.minus_arr('abcdefg'.chars, @solution.segments)
    segs = eight.minus(@solution.segments)
    
    # get diff of 235 to find which segments appear once
    a = @solution.diff(two_three_five, 1)
    bot_left = @solution.inter(segs, a)
    bot = @solution.minus_arr(segs, bot_left)    
    @solution.mark_segment(4, bot_left[0])
    @solution.mark_segment(6, bot[0])
    
    puts "235 0 #{two_three_five[0]}"
    puts "235 1 #{two_three_five[1]}"
    puts "235 2 #{two_three_five[2]}"
    puts "235 diff #{a} "
    puts "235 eight-sol #{segs} "
    puts "bot_left=#{bot_left}"
    puts "bot=#{bot}"
  end

  def solve
    @solution = Digit.new('')
    one = nil
    seven = nil
    four = nil
    eight = nil
    zero_six_nine = []
    two_three_five = []
    @signals.each do |s|
      if s.equals?(1)
        one = s
      elsif s.equals?(7)
        seven = s
      elsif s.equals?(4)
        four = s
      elsif s.equals?(8)
        eight = s
      elsif s.equals?([0,6,9])
        zero_six_nine << s
        #puts "?0,6,9 #{s}"
      elsif s.equals?([2,3,5])
        two_three_five << s
        #puts "?2,3,5 #{s}"
      end
    end
    puts "one #{one}"
    puts "seven #{seven}"
    puts "four #{four}"
    puts "eight #{eight}"

    # 0 is top segment
    solve_for_seg0(seven, one)
    puts "seg0 found: " + @solution.to_s

    # 2 is top right
    # 3 is middle
    # 5 is bot right
    mid = solve_for_seg235(one, four, zero_six_nine)
    puts "seg235 found: " + @solution.to_s

    # 1 is top left
    solve_for_seg1(one, four, mid)
    puts "seg1 found: " + @solution.to_s

    # 4 is bot left
    solve_for_seg46(eight, two_three_five)
    puts "seg46 found: " + @solution.to_s

    # 6 is bot
    # solve_for_seg6()
    puts "FINAL: " + @solution.to_s
    @solution.set_pattern_map

    # @signals.each do |s|
    #   unless s.unique?
    #     s.pattern_to_digit(@solution.sets)
    #   end
    #   puts s
    # end

    @output_value = ""
    @outputs.each do |o|
      o.pattern_to_digit(@solution.sets)
      #puts o.to_s
      @output_value << o.value

    end
    puts @output_value
    @output_value
  end

end

class Notes
  attr :total
  attr :entries

  def initialize(lines)
    @total = 0
    @entries = []
    lines.each do |line|
      # puts "read [#{line}]"
      e = Entry.new(line.chomp)
      #e.print
      @entries << e
    end
  end

  def calc_part1_total
    @entries.each do |e|
      num = e.count_output_unique
      @total += num
    end
    puts "part 1 total: #{@total}"
  end

  def calc_part2_total
    @total = 0
    @entries.each_with_index do |e, i|
      puts "solving entry #{i}"
      val = e.solve
      @total += val.to_i
    end
    puts "part 2 total: #{@total}"
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
  n = Notes.new(lines)
  n.calc_part1_total

end

def part2(input_file)
  lines = read_input(input_file)
  n = Notes.new(lines)
  n.calc_part2_total
end

puts ""
puts "part 1 sample"
part1('aoc_08_2021_input_sample_oneline.txt')

puts ""
puts "=" * 80
puts "part 1 sample"
part1('aoc_08_2021_input_sample.txt')

puts ""
puts "part 1"
part1('aoc_08_2021_input.txt')

puts ""
puts "part 2 sample"
part2('aoc_08_2021_input_sample_oneline.txt')

puts ""
puts "part 2 sample"
part2('aoc_08_2021_input_sample.txt')

puts ""
puts "part 2 sample"
part2('aoc_08_2021_input.txt')


#   0:      1:       2:     3        4     5:
#  aaaa    ....    aaaa    aaaa    ....   aaaa
# b    c  .    c  .    c  .    c  b    c b    .
# b    c  .    c  .    c  .    c  b    c b    .
#  ....    ....    dddd    dddd    dddd   dddd
# e    f  .    f  e    .  .    f  .    f .    f
# e    f  .    f  e    .  .    f  .    f .    f
#  gggg    ....    gggg    gggg    ....   gggg


#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

