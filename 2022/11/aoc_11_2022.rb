#!/usr/bin/env ruby
# coding: utf-8

# https://adventofcode.com/2022/day/11

# --- Day 11: Monkey in the Middle ---
# As you finally start making your way upriver, you realize your pack is much lighter than you remember. Just then, one of the items from your pack goes flying overhead. Monkeys are playing Keep Away with your missing things!

# To get your stuff back, you need to be able to predict where the monkeys will throw your items. After some careful observation, you realize the monkeys operate based on how worried you are about each item.

# You take some notes (your puzzle input) on the items each monkey currently has, how worried you are about those items, and how the monkey makes decisions based on your worry level. For example:

# Monkey 0:
#   Starting items: 79, 98
#   Operation: new = old * 19
#   Test: divisible by 23
#     If true: throw to monkey 2
#     If false: throw to monkey 3

# Monkey 1:
#   Starting items: 54, 65, 75, 74
#   Operation: new = old + 6
#   Test: divisible by 19
#     If true: throw to monkey 2
#     If false: throw to monkey 0

# Monkey 2:
#   Starting items: 79, 60, 97
#   Operation: new = old * old
#   Test: divisible by 13
#     If true: throw to monkey 1
#     If false: throw to monkey 3

# Monkey 3:
#   Starting items: 74
#   Operation: new = old + 3
#   Test: divisible by 17
#     If true: throw to monkey 0
#     If false: throw to monkey 1
# Each monkey has several attributes:

# Starting items lists your worry level for each item the monkey is currently holding in the order they will be inspected.
# Operation shows how your worry level changes as that monkey inspects an item. (An operation like new = old * 5 means that your worry level after the monkey inspected the item is five times whatever your worry level was before inspection.)
# Test shows how the monkey uses your worry level to decide where to throw an item next.
# If true shows what happens with an item if the Test was true.
# If false shows what happens with an item if the Test was false.
# After each monkey inspects an item but before it tests your worry level, your relief that the monkey's inspection didn't damage the item causes your worry level to be divided by three and rounded down to the nearest integer.

# The monkeys take turns inspecting and throwing items. On a single monkey's turn, it inspects and throws all of the items it is holding one at a time and in the order listed. Monkey 0 goes first, then monkey 1, and so on until each monkey has had one turn. The process of each monkey taking a single turn is called a round.

# When a monkey throws an item to another monkey, the item goes on the end of the recipient monkey's list. A monkey that starts a round with no items could end up inspecting and throwing many items by the time its turn comes around. If a monkey is holding no items at the start of its turn, its turn ends.

# In the above example, the first round proceeds as follows:

# Monkey 0:
#   Monkey inspects an item with a worry level of 79.
#     Worry level is multiplied by 19 to 1501.
#     Monkey gets bored with item. Worry level is divided by 3 to 500.
#     Current worry level is not divisible by 23.
#     Item with worry level 500 is thrown to monkey 3.
#   Monkey inspects an item with a worry level of 98.
#     Worry level is multiplied by 19 to 1862.
#     Monkey gets bored with item. Worry level is divided by 3 to 620.
#     Current worry level is not divisible by 23.
#     Item with worry level 620 is thrown to monkey 3.
# Monkey 1:
#   Monkey inspects an item with a worry level of 54.
#     Worry level increases by 6 to 60.
#     Monkey gets bored with item. Worry level is divided by 3 to 20.
#     Current worry level is not divisible by 19.
#     Item with worry level 20 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 65.
#     Worry level increases by 6 to 71.
#     Monkey gets bored with item. Worry level is divided by 3 to 23.
#     Current worry level is not divisible by 19.
#     Item with worry level 23 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 75.
#     Worry level increases by 6 to 81.
#     Monkey gets bored with item. Worry level is divided by 3 to 27.
#     Current worry level is not divisible by 19.
#     Item with worry level 27 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 74.
#     Worry level increases by 6 to 80.
#     Monkey gets bored with item. Worry level is divided by 3 to 26.
#     Current worry level is not divisible by 19.
#     Item with worry level 26 is thrown to monkey 0.
# Monkey 2:
#   Monkey inspects an item with a worry level of 79.
#     Worry level is multiplied by itself to 6241.
#     Monkey gets bored with item. Worry level is divided by 3 to 2080.
#     Current worry level is divisible by 13.
#     Item with worry level 2080 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 60.
#     Worry level is multiplied by itself to 3600.
#     Monkey gets bored with item. Worry level is divided by 3 to 1200.
#     Current worry level is not divisible by 13.
#     Item with worry level 1200 is thrown to monkey 3.
#   Monkey inspects an item with a worry level of 97.
#     Worry level is multiplied by itself to 9409.
#     Monkey gets bored with item. Worry level is divided by 3 to 3136.
#     Current worry level is not divisible by 13.
#     Item with worry level 3136 is thrown to monkey 3.
# Monkey 3:
#   Monkey inspects an item with a worry level of 74.
#     Worry level increases by 3 to 77.
#     Monkey gets bored with item. Worry level is divided by 3 to 25.
#     Current worry level is not divisible by 17.
#     Item with worry level 25 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 500.
#     Worry level increases by 3 to 503.
#     Monkey gets bored with item. Worry level is divided by 3 to 167.
#     Current worry level is not divisible by 17.
#     Item with worry level 167 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 620.
#     Worry level increases by 3 to 623.
#     Monkey gets bored with item. Worry level is divided by 3 to 207.
#     Current worry level is not divisible by 17.
#     Item with worry level 207 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 1200.
#     Worry level increases by 3 to 1203.
#     Monkey gets bored with item. Worry level is divided by 3 to 401.
#     Current worry level is not divisible by 17.
#     Item with worry level 401 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 3136.
#     Worry level increases by 3 to 3139.
#     Monkey gets bored with item. Worry level is divided by 3 to 1046.
#     Current worry level is not divisible by 17.
#     Item with worry level 1046 is thrown to monkey 1.
# After round 1, the monkeys are holding items with these worry levels:

# Monkey 0: 20, 23, 27, 26
# Monkey 1: 2080, 25, 167, 207, 401, 1046
# Monkey 2:
# Monkey 3:
# Monkeys 2 and 3 aren't holding any items at the end of the round; they both inspected items during the round and threw them all before the round ended.

# This process continues for a few more rounds:

# After round 2, the monkeys are holding items with these worry levels:
# Monkey 0: 695, 10, 71, 135, 350
# Monkey 1: 43, 49, 58, 55, 362
# Monkey 2:
# Monkey 3:

# After round 3, the monkeys are holding items with these worry levels:
# Monkey 0: 16, 18, 21, 20, 122
# Monkey 1: 1468, 22, 150, 286, 739
# Monkey 2:
# Monkey 3:

# After round 4, the monkeys are holding items with these worry levels:
# Monkey 0: 491, 9, 52, 97, 248, 34
# Monkey 1: 39, 45, 43, 258
# Monkey 2:
# Monkey 3:

# After round 5, the monkeys are holding items with these worry levels:
# Monkey 0: 15, 17, 16, 88, 1037
# Monkey 1: 20, 110, 205, 524, 72
# Monkey 2:
# Monkey 3:

# After round 6, the monkeys are holding items with these worry levels:
# Monkey 0: 8, 70, 176, 26, 34
# Monkey 1: 481, 32, 36, 186, 2190
# Monkey 2:
# Monkey 3:

# After round 7, the monkeys are holding items with these worry levels:
# Monkey 0: 162, 12, 14, 64, 732, 17
# Monkey 1: 148, 372, 55, 72
# Monkey 2:
# Monkey 3:

# After round 8, the monkeys are holding items with these worry levels:
# Monkey 0: 51, 126, 20, 26, 136
# Monkey 1: 343, 26, 30, 1546, 36
# Monkey 2:
# Monkey 3:

# After round 9, the monkeys are holding items with these worry levels:
# Monkey 0: 116, 10, 12, 517, 14
# Monkey 1: 108, 267, 43, 55, 288
# Monkey 2:
# Monkey 3:

# After round 10, the monkeys are holding items with these worry levels:
# Monkey 0: 91, 16, 20, 98
# Monkey 1: 481, 245, 22, 26, 1092, 30
# Monkey 2:
# Monkey 3:

# ...

# After round 15, the monkeys are holding items with these worry levels:
# Monkey 0: 83, 44, 8, 184, 9, 20, 26, 102
# Monkey 1: 110, 36
# Monkey 2:
# Monkey 3:

# ...

# After round 20, the monkeys are holding items with these worry levels:
# Monkey 0: 10, 12, 14, 26, 34
# Monkey 1: 245, 93, 53, 199, 115
# Monkey 2:
# Monkey 3:
# Chasing all of the monkeys at once is impossible; you're going to have to focus on the two most active monkeys if you want any hope of getting your stuff back. Count the total number of times each monkey inspects items over 20 rounds:

# Monkey 0 inspected items 101 times.
# Monkey 1 inspected items 95 times.
# Monkey 2 inspected items 7 times.
# Monkey 3 inspected items 105 times.
# In this example, the two most active monkeys inspected items 101 and 105 times. The level of monkey business in this situation can be found by multiplying these together: 10605.

# Figure out which monkeys to chase by counting how many items they inspect over 20 rounds. What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?

##############################################################################
# MY NOTES
#

require 'pry'

class Monkey

  attr_accessor :test_true, :test_false, :items, :all_divisors

  attr_reader :times_inspected, :num, :test_val

  def initialize(num: -1, items: [], operation: nil, test: nil, test_true: nil, test_false: nil, part: 1)
    @num = num
    @items = items
    @operation = operation
    @test_val = test
    @test_true = test_true
    @test_false = test_false
    @times_inspected = 0
    @part = part

    # these are set later once all input has been processed.
    @all_divisors = nil
    @true_monkey = nil
    @false_monkey = nil

    parts = @operation.split
    @op_lhs = parts[0]
    unless @op_lhs == 'old'
      raise "lhs op invalid #{@op_lhs} in monkey #{m}"
    end
    @op = parts[1]
    if parts[2] == 'old'
      # if rhs is old then we are squaring so change op to indicate it.
      @op = '^'
      @op_val = nil
    else
      @op_val = parts[2].to_i
    end

  end

  def to_s
    "m#{@num} true=#{@true_monkey.num} false=#{@false_monkey.num} times_inspected=#{times_inspected} items #{items}"
  end

  def set_true_monkey(m)
    if m.num != @test_true
      raise "m.num [#{m.num}] != test_true [#{@test_true}]"
    end
    @true_monkey = m
  end

  def set_false_monkey(m)
    if m.num != @test_false
      raise "m.num [#{m.num}] != test_false [#{@test_false}]"
    end
    @false_monkey = m
  end

  def toss(item)
    if item % @test_val == 0
      @true_monkey.items.push(item)
      #puts "m#{@num} true toss #{item} to #{@true_monkey}"
    else
      @false_monkey.items.push(item)
      #puts "m#{@num} false toss #{item} to #{@false_monkey}"
    end
  end

  def inspect_item(item)
    @times_inspected += 1
    worry = 0
    case @op
    when '*'
      worry  = item * @op_val
    when '+'
      worry  = item + @op_val
    when '^'
      worry = item * item
    else
      raise "op #{@op} not handled in monkey #{m}"
    end
    #puts "m#{@num} inspect #{item} #{@op} #{@op_val} -> #{worry}"
    return worry
  end

  def inspect_and_throw_items
    item = @items.shift
    while !item.nil? do
      # inspect item, perform operation to get new worry level
      item = inspect_item(item)

      # worry level to be divided by three and rounded down to the
      # nearest integer in part 1.  in part 2 no div by 3, so set to 1
      # when doing part 2.  This is naive solution.  Tried it and
      # didn't make it to 1000 iterations after a few minutes.
      #
      # I ended up looking on reddit for hints/tips.  I found posts
      # talking about chinese remainder theorem and modular
      # arithmetic.  These links helped me get started:
      #
      # https://en.wikipedia.org/wiki/Modular_arithmetic
      # https://en.wikipedia.org/wiki/Chinese_remainder_theorem
      # https://github.com/romamik/aoc2022/tree/master/src/day11
      #
      # I will confess that even after reading about all this I still
      # don't quite get it.  I'm not sure I would be able to figure
      # out again if given similar problem.
      #
      # I'll try to write out what I think I know so that next time I
      # have notes/comments to look at.  Working an example out
      # sometimes helps? I did on paper but meh... 
      #
      # Lost link to this explanation from another person...
      #
      # Modular arithmetic is hard to wrap your head around sometimes,
      # but I think this all makes sense. Lets take some number `b`
      # and see the remainder when we divide it by `n`. Let's call the
      # remainder `a`. Well, that's the modulus operator, so `b % n =
      # a`, or `a = b % n`.
      #
      # Let's pretend that if I did plugged numbers into `b` and `n` and I got a value
      # of `a` that was greater than 0, how would I change `b` to get a value of 0
      # for `a`? Of course, just subtract whatever that original value of `a` is - e.g
      # the remainder - and `n` would be able to evenly divide `b`! In other words,
      # `b - a = k*n` for some whole number `k`.
      #
      # OK, so that last part, if `b - a = k*n`, then that is a "congruence relation."
      # Written another way, `a ≡ b (mod n)` is read as "`a` and `b` are congruent
      # modulo `n`."
      #
      # What are some things we know if we have that congruence relation? Let's use
      # some real numbers. `32 % 31 = 1`, or `1 ≡ 32 (mod 31)` (32 divided by 31 has a
      # remainder of 1).
      #
      # Is it always true that `a ≡ a (mod n)`? Yep! This especially makes sense if
      # `a` is less than `n`. So using the above numbers, `32 % 31 = 1`, so I know
      # `1 ≡ 32 (mod 31)` and `1 ≡ 1 (mod 31)`.
      #
      # What if we didn't have 32, what if we had 33? Well, `33 % 31 = 2`.
      # That is, `(32 + 1) % 31 = (1 + 1)`. So you can "add" to both sides.
      #
      # What about multiplication? Let's take `32 * 3 = 96`. Well `96 % 31 = 3`, or
      # `(32 * 3) % 31 = (1 * 3)`. So we can multiply both sides (by whole numbers).
      # 
      # Finally, what if we scale our modulus? `(32 * 2) % (31 * 2) = (1 * 2)`, so
      # that also works!
      #
      # To recap:
      #
      # - `a ≡ a (mod n)`
      # - `a + k ≡ b + k (mod n)`
      # - `a * k ≡ b * k (mod n)`
      # - `a * k ≡ b * k (mod n * k)`
      #
      # OK, awesome, so what does that have to do with our problem? Wait, what is the
      # problem we are having?
      #
      # Well, the `worry` level of our items gets too large. Before, we divided
      # by 3 each turn, so that kept the numbers reasonable. So how can we check
      # that our worry level is divisible by some number `n` without storing
      # the whole large number?
      #
      # Remember, we are trying to check that `0 ≡ b (mod n)` (`n` divides `b`).
      # So rather save the full number `b`, how can we reduce it without losing
      # the useful information?
      #
      # Well, we know that `a ≡ a (mod n)`, so rather than save our full value of `b`,
      # just save the remainder! Addition and multiplication is totally fine if we don't
      # have the original value of `b` because the congruence relation doesn't change.
      #
      # OK, that's great, but we don't want to check just one value of `b`, we'll
      # need to check _several_ values that might divide our "worry" level.
      #
      # And this is the whole trick: you can multiply the divisors together and our equivalence
      # relation doesn't change! Let's say `D` is the product our all our divisors.
      # If `0 ≡ b (mod n)`, then `0 * D = b * D (mod n * D)`.
      #
      if @part == 1
        item = item / 3
      else
        item = item % @all_divisors
      end

      # test worry level, decide where to throw item to next monkey
      toss(item)
      item = @items.shift
    end
  end

end


def read_input(file_name, part)
  file = File.open(file_name)
  input_data = file.read
  input_lines = input_data.split("\n")
  puts "num_lines=#{input_lines.length}"
  monkies = []
  all_divs = 1
  
  monkey_input = []
  # each monkey input takes 6 lines of text and a blank line
  ctr = 0
  0.step(input_lines.length-1, 7) do |i|
    m = input_lines[i..i+6]
    puts "----"
    puts m

    # 0 is monkey number
    # 1 is items
    # 2 is operation
    # 3 is test
    # 4 is if true
    # 5 is if false

    unless m[0].include?('Monkey')
      raise "invalid line, expecting Monkey in first line of #{m}"
    end

    # split line in half by semicolon to get comma sep number/items
    items = m[1].split(':')[1]
    # get array of numbers/items
    items = items.split(',')
    # get rid of white space around each item
    items = items.map{|s| s.strip.to_i}

    unless m[2].include?('Operation: new')
      raise "invalid line, expecting operation in line 2 of #{m}"
    end
    operation = m[2].split('=')[1].strip

    # Test:
    unless m[3].include?('Test: divisible by')
      raise "invalid line #{m[3]}, expecting line 3 to have divisible of #{m}"
    end
    test = m[3].split('by')[1].strip.to_i

    unless m[4].include?('If true: throw to monkey')
      raise "invalid line, expecting if true in line 4 of #{m}"
    end
    true_monkey_throw = m[4].split('monkey')[1].strip.to_i

    unless m[5].include?('If false: throw to monkey')
      raise "invalid line, expecting if true in line 5 of #{m}"
    end
    false_monkey_throw = m[5].split('monkey')[1].strip.to_i

    m = Monkey.new(num: ctr, items: items, operation: operation, test: test,
      test_true: true_monkey_throw, test_false: false_monkey_throw, part: part)

    all_divs *= m.test_val
    
    monkies << m
    ctr += 1
  end


  monkies.each do |m|
    m.set_true_monkey(monkies[m.test_true])
    m.set_false_monkey(monkies[m.test_false])
    m.all_divisors = all_divs
  end

  monkies.each do |m|
    puts m
  end

  return monkies
end

def round(num, monkies)
  # puts "=== Round #{num} start"
  # monkies.each do |m|
  #   puts m
  # end
  monkies.each do |m|
    # puts " --- "
    # puts m
    m.inspect_and_throw_items
    # puts m
  end
  if num == 1 || num == 20 || num % 1000 == 0
    puts "=== Round #{num} end"
     monkies.each do |m|
       puts m
    end
  end
end



def do_part(monkies, rounds, part)
  1.upto(rounds) do |num|
    round(num, monkies)
  end
  monkies.sort_by! {|m| m.times_inspected}
  monkies.reverse!
  puts "ANSWER"
  monkies.each do |m|
    puts m
  end
  answer = monkies[0].times_inspected * monkies[1].times_inspected
  puts answer
end

part = 1
monkies = read_input('aoc_11_2022_sample_input.txt', part)
do_part(monkies, 20, part)

part = 2
monkies = read_input('aoc_11_2022_sample_input.txt', part)
do_part(monkies, 10000, part)


part = 1
monkies = read_input('aoc_11_2022_input.txt', part)
do_part(monkies, 20, part)

part = 2
monkies = read_input('aoc_11_2022_input.txt', part)
do_part(monkies, 10000, part)
