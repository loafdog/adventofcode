#!/usr/bin/env ruby
require 'pry'
require 'time'

# https://adventofcode.com/2018/day/4

# You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so this is as close as you can safely get.

# As you search the closet for anything that might help, you discover that you're not the first person to want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall asleep or wake up while at their post (your puzzle input).

# For example, consider the following records, which have already been organized into chronological order:

# [1518-11-01 00:00] Guard #10 begins shift
# [1518-11-01 00:05] falls asleep
# [1518-11-01 00:25] wakes up
# [1518-11-01 00:30] falls asleep
# [1518-11-01 00:55] wakes up
# [1518-11-01 23:58] Guard #99 begins shift
# [1518-11-02 00:40] falls asleep
# [1518-11-02 00:50] wakes up
# [1518-11-03 00:05] Guard #10 begins shift
# [1518-11-03 00:24] falls asleep
# [1518-11-03 00:29] wakes up
# [1518-11-04 00:02] Guard #99 begins shift
# [1518-11-04 00:36] falls asleep
# [1518-11-04 00:46] wakes up
# [1518-11-05 00:03] Guard #99 begins shift
# [1518-11-05 00:45] falls asleep
# [1518-11-05 00:55] wakes up
# Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always the one whose shift most recently started. Because all asleep/awake times are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.

# Visually, these records show that the guards are asleep at these times:

# Date   ID   Minute
#             000000000011111111112222222222333333333344444444445555555555
#             012345678901234567890123456789012345678901234567890123456789
# 11-01  #10  .....####################.....#########################.....
# 11-02  #99  ........................................##########..........
# 11-03  #10  ........................#####...............................
# 11-04  #99  ....................................##########..............
# 11-05  #99  .............................................##########.....
# The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the guard on duty that day; and Minute, which shows the minutes during which the guard was asleep within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.

# Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

# If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing the best guard/minute combination.

# Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?

# In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).

# While this example listed the entries in chronological order, your entries are in the order you found them. You'll need to organize them before they can be analyzed.

# What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 10 * 24 = 240.)

def parse_line(line, hash)
  parts = line.split(']')
  ts = parts[0][1..-1]
  text = parts[1].strip
  dt = Time.parse(ts)
  puts "#{dt} #{text}"
  
  hash[dt] = {
     'text' => text
  }
end

def read_input(file_name)
  all_inputs = Hash.new

  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    parse_line(input, all_inputs)
  end
  return all_inputs
end


def guard_init(guards, id)
  return if guards.key?(id)
  guards[id] = {
    'id' => id,
    'total' => 0,
    'min' => Hash.new
  }
end

def guard_update(guards, id, t_start, t_end)
  guards[id]['total'] += t_end - t_start
  t_start.upto(t_end-1) do |min|
    if guards[id]['min'].key?(min)
      guards[id]['min'][min] += 1
    else
      guards[id]['min'][min] = 1
    end
  end
end

def brute_force(file_name)
  inputs = read_input(file_name)
  puts "Read #{inputs.length} lines"
  #pp inputs
  #puts "*"*20
    
  sorted_inputs = inputs.sort.to_h
  pp sorted_inputs
  
  guards = Hash.new
  id = 0
  t_start = 0
  t_end = 0
  sorted_inputs.each do |key,record|
    #puts record['text']
    match = /.*\#(\d*) begins shift/.match(record['text'])
    if match
      id = match[1]
      puts "#{id} start"
      guard_init(guards, id)
    elsif 'falls asleep' == record['text']
      puts "  #{id} sleep"
      t_start = key.min
    elsif 'wakes up' == record['text']
      puts "  #{id} wake"
      t_end = key.min
      puts " #{id} slept s=#{t_start} e=#{t_end}"
      guard_update(guards, id, t_start, t_end)
    end
  end
  #pp guards

  # part 1 answer.
  #
  # Sort guards by total minute slept to find guard who slept the most
  sorted_guards = guards.sort_by {|_key, value| value['total']}.reverse
  #pp sorted_guards

  # Now sort minutes slept by guard and take first one which is most
  # minutes slept by that guard
  guard = sorted_guards.first[1]
  pp guard
  sorted_min = guard['min'].sort_by {|_key, value| value}.reverse

  # Multiply guard id by minute to get answer to submit
  id_min = guard['id'].to_i * sorted_min.first[0]
  puts "#{guard['id']} * #{sorted_min.first[0]}(#{sorted_min.first[1]}) = #{id_min}"
  puts ""

  # part 2 answer
  #
  guards.each do |key, guard|
    sorted_min = guard['min'].sort_by {|_key, value| value}
    begin
      guard['max_min'] = sorted_min.last[0]
      guard['max_min_val'] = sorted_min.last[1]
    rescue
      puts "exception #{sorted_min}"
      pp guard
      guard['max_min'] = 0
      guard['max_min_val'] = 0

    end
    
  end
  sorted_guards_by_max_min = guards.sort_by {|_key, value| value['max_min_val']}
  guard = sorted_guards_by_max_min.last[1]
  id_max_min = guard['id'].to_i * guard['max_min'].to_i
  puts "#{guard['id']} * #{guard['max_min']}(#{guard['max_min_val']}) = #{id_max_min}"
end

brute_force('sample.txt')

brute_force('aoc_04_2018_input.txt')
