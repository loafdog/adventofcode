#!/usr/bin/env ruby

# http://adventofcode.com/2017/day/3

# You come across an experimental new kind of memory stored on an
# infinite two-dimensional grid.

# Each square on the grid is allocated in a spiral pattern starting at
# a location marked 1 and then counting up while spiraling
# outward. For example, the first few squares are allocated like this:

# 17  16  15  14  13
# 18   5   4   3  12
# 19   6   1   2  11
# 20   7   8   9  10
# 21  22  23---> ...


# While this is very space-efficient (no squares are skipped),
# requested data must be carried back to square 1 (the location of the
# only access port for this memory system) by programs that can only
# move up, down, left, or right. They always take the shortest path:
# the Manhattan Distance between the location of the data and square
# 1.

# For example:

# Data from square 1 is carried 0 steps, since it's at the access port.

# Data from square 12 is carried 3 steps, such as: down, left, left.

# Data from square 23 is carried only 2 steps: up twice.

# Data from square 1024 must be carried 31 steps.

# How many steps are required to carry the data from the square
# identified in your puzzle input all the way to the access port?

# 325489 -> ?

#############################################################################
# MY NOTES
#############################################################################

# Start by figuring out how to calc the value of each cell based on
# x,y. If no way then have to try creating a grid.

# Some examples...

# 9x9 n = 9
# center 1 = 4,4
# max 81 = 8,8
# ring nums = 32
# ring range = 50-81

# 7x7
# 37  36  35  34  33  32 31
# 38  17  16  15  14  13 30
# 39  18   5   4   3  12 29
# 40  19   6   1   2  11 28
# 41  20   7   8   9  10 27
# 42  21  22  23  24  25 26
# 43  44  45  46  47  48 49  n^2 - x + 1 - n
# 1 = 3,3
# start = 6,5
# end 6,6
# ring nums 24
# ring range 26-49


# 0,0 = 

# 5x5
# 17  16  15  14  13
# 18   5   4   3  12
# 19   6   1   2  11
# 20   7   8   9  10
# 21  22  23  24  25
# 1 = 2,2
# start = 4,3
# end 4,4
# ring nums 16
# ring range 10-25

# 3x3 n = 3
# 5   4   3 
# 6   1   2 
# 7   8   9
#
# 1 = 1,1
# start 2,1
# end 2,2
# ring nums 8 
# ring range 2-9

# 0,1 -> 6  9 - 2 - 1
# 2,1 -> 2  9 - 2 - 2 - 2 - 1
# n^2 - (n - 1) - (n - 1) - (n - 1) - y
# n^2 - 3(n-1) - y

# 2,0 -> 3  9 - 2 - 2 - 2
# 1,0 -> 4  9 - 2 - 2 - 1
# 0,0 -> 5  9 - 2 - 2 - 0
# n^2 - (n - 1) - (n - 1) - x
# n^2 - 2(n - 1) - x

# 0,2 -> 7  9 - 2 + 0
# 1,2 -> 8  9 - 2 + 1
# 2,2 -> 9  9 - 2 + 2
# n^2 + x + 1 - n
# n^2 - (n-1) + x

# 1x1
# 1
# 1 = 0,0


# Equations and stuff.... 

# Center point can be calc'd (n - 1)/2

# Max value in grid is n^2

# start point is (n-1, n-2)
# end point is (n-1, n-1)

# How do you find the value of any square in grid? Look at it as each
# ring is a separate thing. Calc the value of each ring separately.

# ring nums is n*2 + (n-2)*2

# ring range is [n^2 - ring nums - 1, n^2]

# Got formulas for each row/col in ring. See 3x3 grid example.  Now
# need to figure out which formula to apply when.  Based on x,y val,
# pick one...

# if   y = 0   : n^2 - 2(n - 1) - x
# if   y = n-1 : n^2 - (n-1) + x
# else         : n^2 - 3(n-1) - y

# Once you know which quadrant it is in, you can count steps just for
# that one
