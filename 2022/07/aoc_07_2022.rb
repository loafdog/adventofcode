#!/usr/bin/env ruby

# https://adventofcode.com/2022/day/7

# --- Day 7: No Space Left On Device ---
# You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

# The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

# $ system-update --please --pretty-please-with-sugar-on-top
# Error: No space left on device
# Perhaps you can delete some files to make space for the update?

# You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

# $ cd /
# $ ls
# dir a
# 14848514 b.txt
# 8504156 c.dat
# dir d
# $ cd a
# $ ls
# dir e
# 29116 f
# 2557 g
# 62596 h.lst
# $ cd e
# $ ls
# 584 i
# $ cd ..
# $ cd ..
# $ cd d
# $ ls
# 4060174 j
# 8033020 d.log
# 5626152 d.ext
# 7214296 k
# The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called /. You can navigate around the filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

# Within the terminal output, lines that begin with $ are commands you executed, very much like some modern computers:

# cd means change directory. This changes which directory is the current directory, but the specific result depends on the argument:
# cd x moves in one level: it looks in the current directory for the directory named x and makes it the current directory.
# cd .. moves out one level: it finds the directory that contains the current directory, then makes that directory the current directory.
# cd / switches the current directory to the outermost directory, /.
# ls means list. It prints out all of the files and directories immediately contained by the current directory:
# 123 abc means that the current directory contains a file named abc with size 123.
# dir xyz means that the current directory contains a directory named xyz.
# Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

# - / (dir)
#   - a (dir)
#     - e (dir)
#       - i (file, size=584)
#     - f (file, size=29116)
#     - g (file, size=2557)
#     - h.lst (file, size=62596)
#   - b.txt (file, size=14848514)
#   - c.dat (file, size=8504156)
#   - d (dir)
#     - j (file, size=4060174)
#     - d.log (file, size=8033020)
#     - d.ext (file, size=5626152)
#     - k (file, size=7214296)
# Here, there are four directories: / (the outermost directory), a and d (which are in /), and e (which is in a). These directories also contain files of various sizes.

# Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the total size of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

# The total sizes of the directories above can be found as follows:

# The total size of directory e is 584 because it contains a single file i of size 584 and no other directories.
# The directory a has total size 94853 because it contains files f (size 29116), g (size 2557), and h.lst (size 62596), plus file i indirectly (a contains e which contains i).
# Directory d has total size 24933642.
# As the outermost directory, / contains every file. Its total size is 48381165, the sum of the size of every file.
# To begin, find all of the directories with a total size of at most 100000, then calculate the sum of their total sizes. In the example above, these directories are a and e; the sum of their total sizes is 95437 (94853 + 584). (As in this example, this process can count files more than once!)

# Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?

# --- Part Two ---
# Now, you're ready to choose a directory to delete.

# The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.

# In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.

# To achieve this, you have the following options:

# Delete directory e, which would increase unused space by 584.
# Delete directory a, which would increase unused space by 94853.
# Delete directory d, which would increase unused space by 24933642.
# Delete directory /, which would increase unused space by 48381165.
# Directories e and a are both too small; deleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.

# Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?



require 'pry'

class AOCFile

  attr_accessor :name
  attr_accessor :size
  attr_accessor :type
  attr_accessor :total_size
  attr_accessor :parent
  attr_accessor :subdirs
  attr_accessor :files

  def initialize(name, parent=nil, size=0)
    self.name = name
    if self.name == '/'
      self.parent = nil
    else
      self.parent = parent
    end
    if size == 0
      self.type = 'dir'
    else
      self.type = 'file'
    end
    self.size = size
    self.subdirs = {}
    self.files = {}
  end

  def add(type, name)
    if type == 'dir'
      if subdirs.has_key?(name)
        puts "#{self.name} already has dir #{name}"
      else
        puts "adding dir #{name} to #{self.name}"
        subdirs[name] = AOCFile.new(name, self, 0)
      end
    elsif type.scan(/\D/)
      if files.has_key?(name)
        puts "#{self.name} already has file #{name}"
      else
        puts "adding file #{name} size #{type} to #{self.name}"
        files[name] = AOCFile.new(name, self.parent, type.to_i)
      end
    else
      raise "Unrecognized file type #{type} name=#{name}"
    end
  end

  def calc_total_file_size
    total = 0
    self.files.each do |name, aocfile|
      total += aocfile.size
    end
    return total
  end

  def calc_total_subdir_size
    total = 0
    self.subdirs.each do |name, aocfile|
      total += aocfile.size
    end
    return total
  end


  def update_size
    raise 'Cant update size for file type' if self.type == 'file'
    total = 0
    total += calc_total_file_size
    total += calc_total_subdir_size
    self.size = total
    return self.size
  end

  def get_parent
    if self.parent.nil?
      if self.name == '/'
        return self
      else
        raise "parent is nil in #{self.name}?"
      end
    end
    return self.parent
  end

  def find_sub_dir(name)
    subdirs.each do |dirname, aocfile|
      if dirname == name
        return aocfile
      end
    end
    return nil
  end

  def to_s()
    self.to_str
  end

  def to_str()
    if self.type == 'dir'
      type = 'dir'
      return "#{name} (#{type}) total=#{self.size}"
    else
      type = 'file'
      return "#{name} (#{type}, size=#{self.size})"
    end
  end

end


#############################################################################


def print_tree(aocfile, indent)
  puts "#{indent}#{aocfile.to_str}"
  aocfile.subdirs.each do |name, aocfile|
    print_tree(aocfile, indent+'  ')
  end
  aocfile.files.each do |name, aocfile|
    puts "  #{indent}#{aocfile.to_str}"
  end
end

def update_sizes(aocfile)
  aocfile.subdirs.each do |name, aocfile|
    update_sizes(aocfile)
  end
  size = aocfile.update_size
  puts "calc'd size for #{aocfile.to_str}"
end

def sum_dir_size(aocfile, min_size, max_size)
  if max_size != -1
    if aocfile.size < max_size
      total = aocfile.size
    else
      total = 0
    end
  end
  if min_size != -1
    if aocfile.size < min_size
      total = aocfile.size
    else
      total = 0
    end
  end

  aocfile.subdirs.each do |name, aocfile|
    total += sum_dir_size(aocfile, min_size, max_size)
  end

  puts "sum_dir_size size=#{total} for #{aocfile.to_str}"
  return total
end

def get_dirs(aocfile)
  d = [aocfile]
  aocfile.subdirs.each do |name, aocfile|
    d += get_dirs(aocfile)
  end
  return d
end

def read_input(file_name)
  file = File.open(file_name)
  input_data = file.read

  prev_line = ''

  # assume top/root dir is /
  tree = AOCFile.new('/')

  cur_dir = nil

  input_data.each_line do |line|
    line.chomp!
    if line.start_with?('$')
      puts "cmd #{line}"
      (prompt, cmd, arg) = line.split(' ')
      # puts "prompt=#{prompt} cmd=#{cmd}, arg=#{arg}"
      if cmd == 'cd'
        if arg == '/'
          cur_dir = tree
        elsif arg == '..'
          cur_dir = cur_dir.get_parent
        else
          # should we create dir here? or just navigate?
          # AOCFile.new(arg, cur_dir)
          cur_dir = cur_dir.find_sub_dir(arg)
          if cur_dir.nil?
            raise "sub dir not found, should we create or mistake? line=[#{line}]"
          end
        end
      elsif cmd == 'ls'
        # do nothing here b/c next few lines will be output to handle?
      else
        raise "unknown cmd #{cmd} in line=[#{line}]"
      end
    else
      (type,name) = line.split(' ')
      cur_dir.add(type, name)
    end
    prev_line = line
  end
  tree
end

def solve(tree)
  indent=''
  print_tree(tree, indent)
  update_sizes(tree)
  puts ""
  print_tree(tree, indent)

  min_size = -1
  max_size = 100_000
  total = sum_dir_size(tree, min_size, max_size)
  puts "PART 1 total for min=#{min_size} max=#{max_size} dirs is #{total}"
  puts ""

  available_size = 70_000_000
  update_needed_size = 30_000_000
  target_size = available_size - update_needed_size

  free_size = available_size = tree.size
  needed_size = free_size - target_size

  all_dirs = get_dirs(tree)
  # puts all_dirs
  all_dirs.sort_by!{|aocfile| aocfile.size}
  puts all_dirs
  puts ""
  puts "Searching #{all_dirs.length } dirs to free up #{needed_size}"
  answer_aocfile = nil
  all_dirs.each do |d|
    if d.size > needed_size
      answer_aocfile = d
      break
    end
  end
  puts "Found dir to delete #{answer_aocfile}"
end

tree = read_input('aoc_07_2022_sample_input.txt')
solve(tree)

tree = read_input('aoc_07_2022_input.txt')
solve(tree)
