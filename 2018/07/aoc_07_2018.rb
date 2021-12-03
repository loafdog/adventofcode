#!/usr/bin/env ruby
require 'pry'

# https://adventofcode.com/2018/day/7

# You find yourself standing on a snow-covered coastline; apparently, you landed a little off course. The region is too hilly to see the North Pole from here, but you do spot some Elves that seem to be trying to unpack something that washed ashore. It's quite cold out, so you decide to risk creating a paradox by asking them for directions.

# "Oh, are you the search party?" Somehow, you can understand whatever Elves from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the device on your wrist also be a translator? "Those clothes don't look very warm; take this." They hand you a heavy coat.

# "We do need to find our way back to the North Pole, but we have higher priorities at the moment. You see, believe it or not, this box contains something that will solve all of Santa's transportation problems - at least, that's what it looks like from the pictures in the instructions." It doesn't seem like they can read whatever language it's in, but you can: "Sleigh kit. Some assembly required."

# "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at once!" They start excitedly pulling more parts out of the box.

# The instructions specify a series of steps and requirements about which steps must be finished before others can begin (your puzzle input). Each step is designated by a single letter. For example, suppose you have the following instructions:

# Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin.
# Visually, these requirements look like this:


#   -->A--->B--
#  /    \      \
# C      -->D----->E
#  \           /
#   ---->F-----
# Your first goal is to determine the order in which the steps should be completed. If more than one step is ready, choose the step which is first alphabetically. In this example, the steps would be completed as follows:

# Only C is available, and so it is done first.
# Next, both A and F are available. A is first alphabetically, so it is done next.
# Then, even though F was available earlier, steps B and D are now also available, and B is the first alphabetically of the three.
# After that, only D and F are available. E is not available because only some of its prerequisites are complete. Therefore, D is completed next.
# F is the only choice, so it is done next.
# Finally, E is completed.
# So, in this example, the correct order is CABDFE.

# In what order should the steps in your instructions be completed?

# First guess was wrong:
# XYUVGTORMLKDISJBAWPCEQZNHF
# 
# Next guess:
# OUGLTKDJVBRMIXSACWYPEQNHZF
#
# Problem with first guess was I did not account for there being many
# steps possible with start step. And when adding steps to queue
# needed to check for duplicates and remove them.

def parse_line(inputs, line)
  match = /Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin/.match(line)
  #match = /Step ([A-Z]{1}) must.*step ([A-Z]{1}) can.*/.match(line)
  if match
    unless inputs.key?(match[1])
      inputs[match[1]] = Array.new
    end
    inputs[match[1]] << match[2]
  else
    raise "Failed to parse line: #{line}"
  end
end

def read_input(file_name)
  inputs = Hash.new
  file = File.open(file_name)
  input_data = file.read
  input_data.each_line do |line|
    #next if line.start_with?('#')
    #next if line.chomp.empty?
    input = line.chomp.strip
    parse_line(inputs, input)
  end
  return inputs
end

def find_next_steps(inputs)
  vals = inputs.values.flatten.uniq
  steps = Array.new
  inputs.each do |step, val|
    next if vals.include?(step)
    steps << step
  end
  return steps
end

def solve(file_name)

  inputs = read_input(file_name)
  pp inputs

  order = String.new
  q_steps = Array.new

  last_val = nil
  while inputs.length > 0 do
    next_steps = find_next_steps(inputs)
    puts "next_steps #{next_steps}"
    
    q_steps += next_steps
    q_steps.uniq!
    q_steps.sort!

    print "  INPUTS "
    pp inputs
    print "  QUEUE "
    pp q_steps
    
    cur = q_steps.shift
    
    # Remove current step from inputs b/c it was processed
    last_val = inputs.delete(cur)
    order << cur
    puts "order #{order}"
  end
  
  print "DONE INPUTS "
  pp inputs
  print "DONE QUEUE "
  pp q_steps

  puts "last_val #{last_val}"
  order << last_val.first

  puts order

end

def work_time(step, t_now)
  dur = step.bytes[0] - 64
  t_now += dur
  return t_now
end

def find_workers(workers, q_steps, t_now)
  puts "#{__method__} t_now #{t_now} workers=#{workers} q=#{q_steps}"

  max_workers = 2
  working = Array.new
  if workers.length == max_workers
    return working
  end
  q_steps.each do |step|
    next if workers.key?(step)
    workers[step] = {
      't_start' => t_now,
      't_end' => work_time(step, t_now)
    }
    working << step
    q_steps.delete(step)
    if workers.length == max_workers
      return working
    end
  end
  # found = false
  # q_steps.each do |step|
  #   workers.each_index do |w|
  #     if workers[w].nil?
  #       workers[w] = {
  #         'step' => step,
  #         't_start' => t_now,
  #         't_end' => work_time(step, t_now)
  #       }
  #       working << step
  #       q_steps.delete(step)
  #       found = true
  #       break
  #     end
  #   end
  #   # if we didn't find a worker first step then don't bother looking
  #   # for workers for other steps.
  #   break unless found
  # end

  return working
end

def run_workers(workers, t_now)
  puts "#{__method__} t_now=#{t_now} workers=#{workers}"
  done_steps = Array.new
  t_now += 1
  workers.each do |step, info|
    if info['t_end'] == t_now
      done_steps << step
      workers.delete(step)
    end
  end
  return t_now, done_steps
end

def solve2(file_name)

  t_now = 0
  total_time = 0
  #workers = Array.new(2, nil)
  workers = Hash.new

  inputs = read_input(file_name)
  pp inputs

  order = String.new
  q_steps = Array.new

  last_val = nil
  while inputs.length > 0 do
    next_steps = find_next_steps(inputs)
    puts "next_steps #{next_steps}"

    q_steps += next_steps
    q_steps.uniq!
    q_steps.sort!

    print "  INPUTS "
    pp inputs
    print "  QUEUE "
    pp q_steps
    print "  WORKERS "
    pp workers

    # find a worker for each item in q
    working = find_workers(workers, q_steps, t_now)
    working.each do |cur|
      #inputs.delete(cur)
    end

    # determine if worker is done with step.. how?
    t_now, done_steps = run_workers(workers, t_now)
    done_steps.each do |cur|
      # TODO remove cur from inputs and/maybe q
      
      # Remove current step from inputs b/c it was processed
      order << cur
      puts "  order #{order}"
    end

    break if t_now > 5
  end
  
  print "DONE INPUTS "
  pp inputs
  print "DONE QUEUE "
  pp q_steps

  puts "last_val #{last_val}"
  order << last_val.first

  puts order

end

#solve('sample.txt')
#solve('sample2.txt')

#solve('aoc_07_2018_input.txt')

solve2('sample.txt')
